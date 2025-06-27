import { format as _format } from "@std/fmt/duration";
import { execFile as _execFile } from "child_process";
import { promisify } from "util";

export const duration_fmt = (ms: number) => _format(ms, { ignoreZero: true });

export const execFile = promisify(_execFile);
