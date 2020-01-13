import os, parsecfg, terminal, logging, macros, strformat, strutils

const
  IS_DISPLAY = getEnv("log.isDisplay").parseBool
  IS_FILE = getEnv("log.isFile").parseBool
  LOG_DIR = getEnv("log.dir")

proc logger*(output: any, args:varargs[string]) =
  # console log
  if IS_DISPLAY:
    let logger = newConsoleLogger()
    logger.log(lvlInfo, $output & $args)
  # file log
  if IS_FILE:
    # info $output & $args
    let path = LOG_DIR & "/log.log"
    createDir(parentDir(path))
    let logger = newRollingFileLogger(path, mode=fmAppend, fmtStr=verboseFmtStr)
    logger.log(lvlInfo, $output & $args)
    flushFile(logger.file)


proc echoErrorMsg*(msg:string) =
  # console log
  if IS_DISPLAY:
    styledWriteLine(stdout, fgRed, bgDefault, msg, resetStyle)
  # file log
  if IS_FILE:
    let path = LOG_DIR & "/error.log"
    createDir(parentDir(path))
    let logger = newRollingFileLogger(path, mode=fmAppend, fmtStr=verboseFmtStr)
    logger.log(lvlError, msg)
    flushFile(logger.file)
