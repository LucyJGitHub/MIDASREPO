     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Classification Codes Maint')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000203 - Classification Codes Maintenance                  *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  IMPORTANT: This module is a clone of SD000200. Any changes   *
      *  to SD000200 should be reflected to this module               *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034079           Date 10Apr15               *
      *                 MD033531           Date 16Mar14               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034079 - IO error on display file                          *
      *  MD033531 - I/O error on '?' Processing                       *
      *  CGL154 - FATCA Phase 2 - FATCA Reporting                     *
      *                                                               *
      *****************************************************************
     FSD000203DFCF   E             WORKSTN SFILE(SD000200S0:SflRRN)
     F                                     INFSR(*PSSR)
 
      ** Classification Codes File - Output
     F***SDFATCPD  IF   E             DISK                                                  MD033531
     FSDFATCL0  IF   E           K DISK                                                     MD033531
 
     D Up              C                   'ABCDEFGHIJKLMNOPQRS-
     D                                     TUVWXYZ'
     D Lo              C                   'abcdefghijklmnopqrs-
     D                                     tuvwxyz'
      *
     D Mode            S              7A
     D ReturnDS        DS
     D RetCode                        7A
     D ClsCode                        5A
     D ClsDesc                       50A
      *
     D DetActn         S              1A
     D DetMode         S              7A
     D DetRetCode      S              7A
     D DetClsCode      S              5A
      *
     D PJob            S             10
     D PUser           S             10
     D SFlRRN          S              4  0
     D FilterCode      S              5
     D FilterDesc      S             50
     D Err             S              1  0
     D Recursive       S              1    INZ('N')
      *
     D ZAPGM           S             10    INZ(*Blanks)
     D ZAPGRL          S              5    INZ(*Blanks)
     D ZAMSID          S              7    INZ(*Blanks)
     D ZAMSGF          S             10    INZ(*Blanks)
     D ZAMSDA          S            132    INZ(*Blanks)
     D ZAMSTP          S              7    INZ(*Blanks)
     D FrsPass         S              1    INZ(*Blanks)
     D WMatchFound     S              1
     D WFilterDesc     S             50
     D WFCDESC         S             50
     D WWDPCD          S             50
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS ICD retrieval
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR BANK DETAILS ICD retrieval
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, Long Data Structure
     D FatCDS        E DS                  EXTNAME(SDFATCPD)
 
     D*/COPY ZACPYSRC,PSDS
 
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
 
      ** Job name
     D PSJobName             244    253
 
      ** User name
     D PSUser                254    263
     D/COPY ZACPYSRC,STD_D_SPEC
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode
     C                   PARM                    ReturnDS
     C
     C
     C                   EVAL      ZAPGM = PSProcName
     C                   EVAL      SPGM = PSProcName
     C                   EVAL      DJOB = PSJobName
     C                   EVAL      DCUSR = PSUser
     C                   EVAL      *IN70 = *OFF
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL133'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANKS
     C                             and Mode = '*MAINT'
     C                   EVAL      Mode = '*ENQRY'
     C                   ENDIF
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** DATABASE ERROR
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C                   EVAL      *IN74 = *OFF
     C                   EVAL      *IN75 = *OFF
     C                   EVAL      *IN76 = *OFF
 
     C                   IF        Mode = '*MAINT'
     C                   EVAL      *IN74 = *ON
     C                   ELSEIF    Mode = '*SELECT'
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN70 = *ON
     C                   ELSEIF    Mode = '*ENQRY'
     C                   EVAL      *IN76 = *ON
     C                   ENDIF
 
      ** Return point for Refresh option.
 
     C     START         TAG
 
      ** Initialise subfile.
 
     C                   EXSR      InitSfl
 
      ** Build  subfile.
 
     C                   EXSR      BuildSfl
 
      ** Process when action taken from screen.
 
     C                   IF        *INKI = *ON
 
      ** If F9 taken invoke detail screen for insert.
 
     C                   EVAL      DetActn = 'I'
     C                   EXSR      DetPgm
     C                   EVAL      *IN05 = *ON
     C                   ENDIF
 
     C     PRCSSBFL      TAG
 
     C                   IF        *IN79 = *ON
     C                   EXSR      ProcSfl
     C                   ENDIF
 
     C                   IF        *IN03 = *OFF
     C                   GOTO      START
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ProcSfl - Process subfile                                     *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ProcSfl       BEGSR
 
      ** If F3 or F5 taken then leave subroutine.
 
     C                   IF        *IN03 = *ON or
     C                             *IN05 = *ON
     C                   EVAL      DPCC = *BLANKS
     C                   EVAL      DPCD = *BLANKS
     C                   EVAL      DCACTN = *BLANK
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *ON
     C                   GOTO      ProcSflE
     C                   ENDIF
 
      ** If user has used an option on a record
 
     C                   READC     SD000200S0
     C                   IF        (%EOF) AND
     C                             DPCC = *BLANKS AND
     C                             DPCD = *BLANKS OR
     C                             WWDPCD <> *BLANKS AND
     C                             DPCD = *BLANKS
     C                   EVAL      WWDPCD = *BLANKS
     C                   EVAL      DCACTN = *BLANK
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *ON
     C                   GOTO      ProcSflE
     C                   ENDIF
     C                   DOW       NOT(%EOF)
     C                   IF        DCACTN <> *BLANKS
     C                   EXSR      ValidateOpt
 
     C                   IF        Err = 0 and
     C                             (Mode = '*MAINT' or Mode = '*ENQRY')
 
      ** Process details
 
     C                   EVAL      DetActn = DCACTN
     C                   EVAL      DetClsCode = DCCODE
     C                   EXSR      DetPgm
     C                   ENDIF
     C                   ENDIF
 
      ** Reset validated/processed option taken
 
     C                   UPDATE    SD000200S0
     C                   EVAL      *IN33 = *OFF
     C                   READC     SD000200S0
     C                   ENDDO
 
      ** Set the cursor to the first record if there is no action taken
 
     C                   IF        Err = 0
     C                   EVAL      MATCH = 1
 
      ** If user has been asked to move to position to subfile.
 
     C                   IF        DPCC <> *blank
     C                   EVAL      FilterCode = DPCC
     C                   EVAL      *IN05 = *ON
     C                   GOTO      ProcSflE
     C                   ENDIF
 
     C                   EVAL      WWDPCD = *BLANKS
     C                   IF        DPCD <> *blank
     C                   EVAL      FilterDesc = DPCD
     C                   EVAL      *IN05 = *ON
     C                   EVAL      WWDPCD = DPCD
     C                   GOTO      ProcSflE
     C                   ENDIF
 
     C                   ENDIF
 
      ** Re-display the subfile with the changes if there are any
 
     C                   IF        *IN03 <> '1'
     C                   EVAL      *IN82 = *ON
     C                   WRITE     SD000200F0
     C                   EXFMT     SD000200C0
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      FrsPass = ' '
     C                   EVAL      Err = 0
     C                   GOTO      PRCSSBFL
     C                   ENDIF
 
     C     ProcSflE      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ClrMsgQue - Clear program message queue                       *
      *                                                               *
      * Called by:                                                    *
      *****************************************************************
      *
     C     ClrMsgQue     BEGSR
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * InitSfl - Initialise subfile                                  *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     InitSfl       BEGSR
 
     C                   EVAL      WWDPCD = *BLANKS
     C                   EVAL      SflRRN = 0
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000200C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      MATCH = 1
     C                   WRITE     #MSGCTL
 
     C                   SELECT
     C                   WHEN      MODE = '*MAINT'
     C                   EVAL      *IN77 = *OFF
     C                   WHEN      MODE = '*SELECT'
     C                   EVAL      *IN77 = *ON
     C                   WHEN      MODE = '*ENQRY'
     C                   EVAL      *IN76 = *ON
     C                   OTHER
     C                   EXSR      *PSSR
     C                   ENDSL
 
     C     InitSflE      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * BuildSfl - Build subfile                                      *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     BuildSfl      BEGSR
 
     C                   EVAL      WMatchFound = 'N'
     C*****1****         SETLL     SDFATCD0                                                 MD033531
     C     *LOVAL        SETLL     SDFATCD0                                                 MD033531
     C                   READ      SDFATCD0
     C                   IF        %EOF <> '0'
 
      ** No Data to Display
 
     C                   EXSR      NoRecords
     C                   ENDIF
 
      **  Else, Fill SubFile
 
     C                   EVAL      SflRRN = 1
     C                   EVAL      MATCH = 0
     C                   DOW       %EOF <> '1'
     C                   IF        FCRECI = '*'
     C                   GOTO      ReadNext
     C                   ENDIF
 
     C                   IF        MATCH = 0
     C                             AND (DPCC <> *BLANKS
     C                             OR   DPCD <> *BLANKS)
     C                   EXSR      FINDMATCH
     C                   ELSE
     C                   IF        MATCH = 0
     C                   EVAL      MATCH = 1
     C                   ENDIF
     C                   EVAL      WFilterDesc = FilterDesc
     C                   EVAL      WFCDESC = FCDESC
     C                   EVAL      WFilterDesc = %XLATE(Up:Lo:WFilterDesc)
     C                   EVAL      WFCDESC = %XLATE(Up:Lo:WFCDESC)
 
     C                   IF        DPCD <> *BLANKS AND
     C                             %scan(%trim(WFilterDesc):WFCDESC:1) = 0
     C                   GOTO      ReadNext
     C                   ENDIF
     C                   ENDIF
     C
     C                   EVAL      DCCODE = FCCODE
     C                   EVAL      DCDESC = FCDESC
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000200S0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      SflRRN = SflRRN + 1
 
     C     ReadNext      TAG
     C                   READ      SDFATCD0
     C                   ENDDO
 
      ** Only inactive/deleted records exist
 
     C                   IF        SflRRN < 1
     C                   EXSR      NoRecords
     C                   ENDIF
 
 
      ** Display subfile / Prompt user selection
 
     C                   IF        WMatchFound = 'N'
     C                             AND (DPCC <> *BLANKS
     C                             OR   DPCD <> *BLANKS)
     C                   EVAL      SflRRN = 0
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN79 = *OFF
     C                   WRITE     SD000200C0
     C                   EVAL      *IN80 = *OFF
     C                   EXSR      NoRecords
     C                   EVAL      FilterCode = *BLANKS
     C**********         EVAL      DPCC = *BLANKS                                           MD034079
     C                   EVAL      FilterDesc = *BLANKS
     C**********         EVAL      DPCD = *BLANKS                                           MD034079
     C                   EVAL      *IN79 = '1'                                              MD034079
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
     C**********         GOTO      START                                                    MD034079
 
     C                   ELSE
     C                   EVAL      *IN82 = *ON
     C                   WRITE     SD000200F0
     C                   EXFMT     SD000200C0
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
     C                   ENDIF
 
     C     BuildSflE     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * NoRecords - Notify user that there are no active records      *
      *                                                               *
      * Called by: BuildSfl                                           *
      *                                                               *
      *****************************************************************
      *
     C     NoRecords     BEGSR
 
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0307'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   EVAL      *IN79 = *OFF
     C                   EVAL      SflRRN = SflRRN + 1
     C                   WRITE     SD000200S0
     C                   EXFMT     SD000200C0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateOpt - Check option taken in regard of current mode    *
      *                                                               *
      * Called by: ProcSfl                                            *
      *                                                               *
      * Calls: //SPF Validation                                       *
      *                                                               *
      *****************************************************************
      *
     C     ValidateOpt   BEGSR
 
     C                   EVAL      Err = 0
     C                   SELECT
 
     C                   WHEN      MODE = '*SELECT' AND DCACTN = '1'
 
     C                   EVAL      RetCode = *BLANKS
     C                   EVAL      ClsCode = DCCODE
     C                   EVAL      ClsDesc = DCDESC
 
     C                   EVAL      *IN03 = *ON
 
     C                   WHEN      (MODE = '*MAINT' AND
     C                                 ( DCACTN = 'A'
     C                                OR DCACTN = 'D'
     C                                OR DCACTN = 'E' ) )
     C                             OR
     C                             (MODE = '*ENQRY' AND DCACTN = 'E')
 
      ** Check if delete is allowed
 
     C                   IF        DCACTN = 'D' and BJSUC = 'Y'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0313'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C
     C                   EVAL      Err = 1
 
     C                   ENDIF
     C
     C                   OTHER
 
      ** DDACTN is not a valid option
 
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   SELECT
     C                   WHEN      Mode = '*SELECT'
     C                   MOVEL     'USS0319'     ZAMSID
     C                   WHEN      Mode = '*ENQRY'
     C                   MOVEL     'USS0318'     ZAMSID
     C                   WHEN      Mode = '*MAINT'
     C                   MOVEL     'USS0316'     ZAMSID
     C                   ENDSL
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C
     C                   EVAL      Err = 1
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN33 = *ON
     C                   IF        FrsPass = ' '
     C                   EVAL      MATCH = 1
     C                   EVAL      FrsPass = '1'
     C                   ENDIF
 
     C                   ENDSL
 
     C     ValidateOptE  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FindMatch - Check if record matches the filter                *
      *                                                               *
      *                                                               *
      * Called by: BldSfl   s                                         *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     FindMatch     BEGSR
 
     C                   IF        FilterCode <> *BLANKS
 
      ** Check Code Filter Match
 
     C**********         IF        %trim(FilterCode) =                                      MD034079
     C**********                    %subst(FCCODE:1:%len(%trim(FilterCode)))                MD034079
     C**********                   and Match = 1                                            MD034079
     C                   IF        FilterCode = FCCODE                                      MD034079
     C                   EVAL      WMatchFound = 'Y'
     C                   EVAL      MATCH = SflRRN
     C**********         EVAL      FilterCode = *BLANKS                                     MD034079
     C**********         EVAL      FilterDesc = *BLANKS                                     MD034079
     C                   ENDIF
 
     C                   ELSEIF    FilterDesc <> *BLANKS
 
     C                   EVAL      WWDPCD = FilterDesc
     C                   EVAL      WFilterDesc = FilterDesc
     C                   EVAL      WFCDESC = FCDESC
     C                   EVAL      WFilterDesc = %XLATE(Up:Lo:WFilterDesc)
     C                   EVAL      WFCDESC = %XLATE(Up:Lo:WFCDESC)
 
      ** Check Description Filter Match
 
     C                   IF        %scan(%trim(WFilterDesc):WFCDESC:1) > 0
     C                   EVAL      WMatchFound = 'Y'
     C                   EVAL      MATCH = SflRRN
     C                   ENDIF
 
     C                   ENDIF
 
     C     FindMatchE    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DetPgm - Invoke details processing program according to mode  *
      *          /option taken                                        *
      *                                                               *
      * Called by: ProcSfl                                            *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     DetPgm        BEGSR
 
     C                   CALL      'SD000201'
     C                   PARM                    DetActn
     C                   PARM      Mode          DetMode
     C                   PARM      *Blanks       DetRetCode
     C                   PARM                    DetClsCode
 
     C                   IF        DetRetCode <> *Blanks
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      DetActn = *Blanks
     C                   EVAL      DetMode = *Blanks
     C                   EVAL      DetRetCode = *Blanks
     C                   EVAL      DetClsCode = *Blanks
     C                   EVAL      DCACTN = *BLANKS
     C                   EVAL      MATCH = SflRRN
     C                   SETON                                        35
 
     C     DetPgmE       ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
      *
     C     ZASNMS        BEGSR
 
     C                   IF        ZAMSGF = *BLANKS
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   END
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
     C                   MOVEL     *BLANKS       ZAMSGF
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAPGRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
