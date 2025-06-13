/**
 * A simple assets server that can only be used for development
 *
 * @module
 */

import http, { IncomingMessage, ServerResponse } from "node:http";
import fs from "node:fs";
import path from "node:path";

import { ROOT_DIR } from "./cli_util.ts";

/**
 * Usage: `assets_server.listen(8000, "localhost")`
 */
export const assets_server = http.createServer(
  (req: IncomingMessage, res: ServerResponse) => {
    const reqUrl = req.url || "/";
    const filePath = path.join(ROOT_DIR, "public", reqUrl);
    fs.readFile(filePath, (err, content) => {
      if (err) {
        res.writeHead(404, { "Content-Type": "text/plain" });
        res.end("Not Found");
      } else {
        const ext = path.extname(filePath).toLowerCase();
        const mimeTypes: Record<string, string> = {
          ".html": "text/html",
          ".js": "application/javascript",
          ".css": "text/css",
        };
        const contentType = mimeTypes[ext] ?? "application/octet-stream";
        res.writeHead(200, {
          "Content-Type": contentType,
          "Access-Control-Allow-Origin": "*",
        });
        res.end(content);
      }
    });
  },
);
