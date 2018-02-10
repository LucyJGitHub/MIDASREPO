     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR MBI Write to IFS')                            *
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR001005 - Midas MR MBI Write to IFS                         *
      *                                                               *
      *  Function: This program is used to write to the integrated    *
      *            File System.                                       *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR844222 *CREATE   Date 30Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR844222 - MBI signal file format update (CCR003)            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D mkdir           PR            10I 0 ExtProc('mkdir')
     D  path1@                         *   Value options(*String)
     D  mode1                        10U 0 Value
 
     D open            PR            10I 0 ExtProc('open')
     D  path@                          *   Value options(*String)
     D  oflag                        10I 0 Value
     D  mode                         10U 0 Value Options(*nopass)
     D  codepage                     10U 0 Value Options(*nopass)
 
     D write           PR            10I 0 Extproc('write')
     D  FileDescO                    10I 0 Value
     D  bufferO@                       *   Value
     D  nbyte                        10U 0 Value
 
     D close           PR            10I 0 Extproc('close')
     D  FileDesc                     10I 0 Value
 
     D O_WRONLY        C                   CONST(02)
     D O_CREATE        C                   CONST(08)
     D O_SHARE_NONE    C                   CONST(524288)
     D O_CODEPAGE      C                   CONST(8388608)
     D O_TEXTDATA      C                   CONST(16777216)
 
     D S_IRWXU         C                   CONST(448)
     D S_IRWXG         C                   CONST(56)
     D S_IRWXO         C                   CONST(07)
     D S_IROTH         C                   CONST(04)
     D S_IXOTH         C                   CONST(01)
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Copyright Statement Array
 
     D CPY@            S             80A   DIM(1) CTDATA
 
      ** Local Data Area Data Structure
 
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Program Status Data Structure
 
     D PSDS           SDS
     D  PSProcName       *PROC
     D  PSPgmStat        *STATUS
     D  PSJobName            244    253
     D  PSUser               254    263
     D  PSProcPgm            334    343
     D  PSProcMod            344    353
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PTRTY           S              2A
     D PTRST           S              2A
     D PTRCL           S              4A
     D PSARD           S              6A
     D PPath           S            200A
     D PathName        S            100A   INZ(*BLANKS)
     D PData           S            100A
     D PFile           S             20A
 
      ** Working Variables
 
     D WPath           S            200A
     D WPos            S              3  0
     D Mode            S             10I 0 INZ
     D Mode1           S             10I 0 INZ
     D Oflag           S             10I 0 INZ
     D FDescDat        S             10I 0
     D RC              S             10I 0
     D RC1             S             10I 0
     D Codepage        S              3  0 INZ(819)
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    PPath
     C                   PARM                    PFile
     C                   PARM                    PData
 
     C                   EVAL      PathName = '/' + %TRIMR(PPath) +
     C                                        '/' + %TRIMR(PFile)
 
     C                   EVAL      Oflag = O_CREATE + O_WRONLY +
     C                                     O_TEXTDATA + O_SHARE_NONE
 
     C                   EVAL      Mode  = S_IRWXU + S_IRWXG +
     C                                     S_IROTH + S_IXOTH
     C                   EVAL      Mode1 = S_IRWXU + S_IRWXG +
     C                                     S_IRWXO
 
     C                   EVAL      FDescDat = OPEN(%TRIMR(PathName) :
     C                                      Oflag : mode : Codepage)
 
     C                   IF        FDescDat < 0
 
      ** Make Directory to build the path if not found.
 
     C                   EVAL      WPos  = 0
     C                   DOU       WPos  = 0
     C                   EVAL      WPos  = %SCAN('/':PPath:WPos+1)
     C                   IF        WPos  > 0
     C                   EVAL      WPath = %SUBST(PPath:1:WPos-1)
     C                   ELSE
     C                   EVAL      WPath = PPath
     C                   ENDIF
     C                   EVAL      RC1   = MKDIR('/'+%TRIMR(WPath):Mode)
     C                   ENDDO
 
     C                   EVAL      FDescDat = OPEN(%TRIMR(PathName) :
     C                                      Oflag : mode : Codepage)
     C                   ENDIF
 
     C                   EVAL      RC = WRITE(FDescDat : %ADDR(PData) :
     C                                         %LEN(%TRIMR(PData)))
 
     C                   EVAL      RC = CLOSE(FDescDat)
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   CALL      'DBERRCTL'
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2011
