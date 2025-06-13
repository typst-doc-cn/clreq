/**
 * A simple server to preview `dist/` that can only be used for development
 *
 * @module
 */

import http, { IncomingMessage, ServerResponse } from "node:http";
import fs from "node:fs";
import path from "node:path";

import { ROOT_DIR } from "./cli_util.ts";

const base = "/clreq/";

const server = http.createServer(
  (req: IncomingMessage, res: ServerResponse) => {
    const reqUrl = req.url || base;

    if (reqUrl.startsWith(base)) {
      let relativePath = reqUrl.slice(base.length);
      if (relativePath === "" || relativePath.endsWith("/")) {
        relativePath += "index.html";
      }
      const filePath = path.join(ROOT_DIR, "dist", relativePath);

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
          res.writeHead(200, { "Content-Type": contentType });
          res.end(content);
        }
      });
    } else {
      res.writeHead(302, { Location: base });
      res.end();
    }
  },
);

server.listen(4173, "localhost");

console.log(`Listening at http://localhost:4173${base}`);
