     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD FATCA Classification Codes Maint - List')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000200 - Classification Codes Maintenance                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD034087           Date 11Apr15               *
      *  Prev Amend No. MD034079           Date 10Apr15               *
      *                 MD033128           Date 25Feb15               *
      *                 MD036917           Date 22Dec15               *
      *                 MD036806           Date 14Dec15               *
      *                 MD033546           Date 08Apr15               *
      *                 MD029834           Date 27Aug14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD034087 - Incorrect behavior when selecting a record in     *
      *             FATCA Classification Code                         *
      *  MD034079 - IO error on display file                          *
      *  MD033128 - FATCA Classification Code cannot be added after   *
      *             switch ON of CGL132 (FATCA Ph1), thus blocking    *
      *             FATCA Initialization process                      *
      *  MD036917 - Classification Codes not sorted alphabetically    *
      *             which prevents filtering when not using the whole *
      *             classification code                               *
      *  MD036806 - User is unable to add a new classification code   *
      *             after enquiring or amending an existing           *
      *             Classification Code                               *
      *  MD033546 - Filter not working in FATCA Classification Codes  *
      *             Maintenance                                       *
      *           - Applied for MD-36807                              *
      *  MD029834 - FATC description filter not working               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
     FSD000200DFCF   E             WORKSTN SFILE(SD000200S0:SflRRN)
     F                                     INFSR(*PSSR)
 
      ** Classification Codes File - Output
     F***SDFATCPD  IF   E             DISK                                                  MD036917
     FSDFATCL1  IF   E           K DISK                                                     MD036917
 
     D Up              C                   'ABCDEFGHIJKLMNOPQRS-                            MD029834
     D                                     TUVWXYZ'                                         MD029834
     D Lo              C                   'abcdefghijklmnopqrs-                            MD029834
     D                                     tuvwxyz'                                         MD029834
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
     D FrsPass         S              1    INZ(*Blanks)                                     MD029834
     D WMatchFound     S              1                                                     MD029834
     D WFilterDesc     S             50                                                     MD029834
     D WFCDESC         S             50                                                     MD029834
     D WWDPCD          S             50                                                     MD029834
     D NoRecSts        S              1A   INZ(*OFF)                                        MD033128
      *
      *
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
     C                   EVAL      *IN70 = *OFF                                             MD029834
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CGL133'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        @RTCD = *BLANKS
     C                             and Mode = '*MAINT'
     C                   EVAL      Mode = '*ENQRY'
     C                   ENDIF
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
     C                   EVAL      *IN74 = *OFF
     C                   EVAL      *IN75 = *OFF
     C                   EVAL      *IN76 = *OFF
 
     C                   IF        Mode = '*MAINT'
     C                   EVAL      *IN74 = *ON
     C                   ELSEIF    Mode = '*SELECT'
     C                   EVAL      *IN75 = *ON
     C                   EVAL      *IN70 = *ON                                              MD029834
     C                   ELSEIF    Mode = '*ENQRY'
     C                   EVAL      *IN76 = *ON
     C                   ENDIF
 
      *
      * Return point for Refresh option.
     C     START         TAG
 
      * Initialise subfile.
     C                   EXSR      InitSfl
      *
      * Build  subfile.
     C                   EXSR      BuildSfl
      *
      * Process when action taken from screen.
 
     C     PRCSSF9       TAG                                                                MD036806
                                                                                            MD036806
     C                   IF        *INKI = *ON
      * If F9 taken invoke detail screen for insert.
     C                   EVAL      DetActn = 'I'
     C                   EXSR      DetPgm
     C                   EVAL      *IN05 = *ON
     C                   ENDIF
                                                                                            MD029834
     C     PRCSSBFL      TAG                                                                MD029834
      *
     C                   IF        *IN79 = *ON
     C                   EXSR      ProcSfl
     C                   ENDIF
      *
     C                   IF        *IN03 = *OFF
     C                   GOTO      START
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
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
      *
      * If F3 or F5 taken then leave subroutine.
     C                   IF        *IN03 = *ON or
     C                             *IN05 = *ON
     C                   EVAL      DPCC = *BLANKS
     C                   EVAL      DPCD = *BLANKS
     C                   EVAL      NoRecSts = *OFF                                          MD034079
     C                   EVAL      DCACTN = *BLANK                                          MD029834
     C                   EVAL      *IN33 = *OFF                                             MD029834
     C                   EVAL      *IN34 = *ON                                              MD029834
     C                   GOTO      ProcSflE
     C                   ENDIF
      *
      * If user has been asked to move to position to subfile.
     C**********         IF        DPCC <> *blank                                           MD029834
     C**********         EVAL      FilterCode = DPCC                                        MD029834
     C**********         EVAL      *IN05 = *ON                                              MD029834
     C**********         GOTO      ProcSflE                                                 MD029834
     C**********         ENDIF                                                              MD029834
 
     C**********         IF        DPCD <> *blank                                           MD029834
     C**********         EVAL      FilterDesc = DPCD                                        MD029834
     C**********         EVAL      *IN05 = *ON                                              MD029834
     C**********         GOTO      ProcSflE                                                 MD029834
     C**********         ENDIF                                                              MD029834
     C
      *
      * If user has used an option on a record
 
     C                   READC     SD000200S0
     C                   IF        (%EOF) AND                                               MD029834
     C                             DPCC = *BLANKS AND                                       MD029834
     C                             DPCD = *BLANKS OR                                        MD029834
     C                             WWDPCD <> *BLANKS AND                                    MD029834
     C                             DPCD = *BLANKS                                           MD029834
     C                   EVAL      WWDPCD = *BLANKS                                         MD029834
     C                   EVAL      DCACTN = *BLANK                                          MD029834
     C                   EVAL      *IN33 = *OFF                                             MD029834
     C                   EVAL      *IN34 = *ON                                              MD029834
     C                   GOTO      ProcSflE                                                 MD029834
     C                   ENDIF                                                              MD029834
     C                   DOW       NOT(%EOF)
     C                   IF        DCACTN <> *BLANKS
     C                   EXSR      ValidateOpt
     C**********         ENDIF                                                              MD029834
 
     C                   IF        Err = 0 and
     C                             (Mode = '*MAINT' or Mode = '*ENQRY')
      * Process details
     C                   EVAL      DetActn = DCACTN
     C                   EVAL      DetClsCode = DCCODE
     C                   EXSR      DetPgm
     C                   ENDIF
     C                   ENDIF                                                              MD029834
 
      * Reset validated/processed option taken
     C**********         EVAL      DCACTN = ''                                              MD029834
     C                   UPDATE    SD000200S0                                               MD029834
     C                   EVAL      *IN33 = *OFF                                             MD029834
     C                   READC     SD000200S0
     C                   ENDDO
                                                                                            MD029834
      ** Set the cursor to the first record if there is no action taken                     MD029834
                                                                                            MD029834
     C                   IF        Err = 0                                                  MD029834
     C                   EVAL      MATCH = 1                                                MD029834
      *                                                                                     MD029834
      * If user has been asked to move to position to subfile.                              MD029834
     C                   IF        DPCC <> *blank                                           MD029834
     C                   EVAL      FilterCode = DPCC                                        MD029834
     C                   EVAL      *IN05 = *ON                                              MD029834
     C                   EVAL      NoRecSts = *OFF                                          MD034087
     C                   GOTO      ProcSflE                                                 MD029834
     C                   ENDIF                                                              MD029834
                                                                                            MD029834
     C                   EVAL      WWDPCD = *BLANKS                                         MD029834
     C                   IF        DPCD <> *blank                                           MD029834
     C                   EVAL      FilterDesc = DPCD                                        MD029834
     C                   EVAL      *IN05 = *ON                                              MD029834
     C                   EVAL      WWDPCD = DPCD                                            MD029834
     C                   GOTO      ProcSflE                                                 MD029834
     C                   ENDIF                                                              MD029834
                                                                                            MD029834
     C                   ENDIF                                                              MD029834
                                                                                            MD029834
      ** Re-display the subfile with the changes if there are any                           MD029834
                                                                                            MD029834
     C                   EVAL      *IN82 = *ON                                              MD029834
     C                   WRITE     SD000200F0                                               MD029834
     C                   EXFMT     SD000200C0                                               MD029834
     C                   EXSR      ClrMsgQue                                                MD029834
     C                   WRITE     #MSGCTL                                                  MD029834
     C                   EVAL      *IN35 = *OFF                                             MD029834
     C                   EVAL      *IN33 = *OFF                                             MD029834
     C                   EVAL      FrsPass = ' '                                            MD029834
     C                   EVAL      Err = 0                                                  MD029834
     C                   IF        *IN09 = '1'                                              MD036806
     C                   GOTO      PRCSSF9                                                  MD036806
     C                   ENDIF                                                              MD036806
     C                   GOTO      PRCSSBFL                                                 MD029834
      *
     C     ProcSflE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ClrMsgQue - Clear program message queue                       *
      *                                                               *
      * Called by:                                                    *
      *****************************************************************
      *
     C     ClrMsgQue     BEGSR
 
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL
 
     C                   ENDSR
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
      *
     C                   EVAL      WWDPCD = *BLANKS                                         MD029834
     C                   EVAL      SflRRN = 0
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000200C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      MATCH = 1
     C**********         EVAL      DPCC = *BLANKS                                           MD029834
     C**********         EVAL      DPCD = *BLANKS                                           MD029834
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
      *
     C     InitSflE      ENDSR
      *
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
      *
     C                   EVAL      WMatchFound = 'N'                                        MD029834
     C*****1****         SETLL     SDFATCD0                                                 MD036917
     C     *LOVAL        SETLL     SDFATCD0                                                 MD036917
     C                   READ      SDFATCD0
     C                   IF        %EOF <> '0'
      *
      **  No Data to Display
      *
     C                   EXSR      NoRecords
     C                   ENDIF
      *
      **  Else, Fill SubFile
     C                   EVAL      SflRRN = 1                                               MD029834
     C                   EVAL      MATCH = 0                                                MD029834
     C                   DOW       %EOF <> '1'
     C                   IF        FCRECI = '*'
     C                   GOTO      ReadNext
     C                   ENDIF
 
     C**********         EVAL      SflRRN = SflRRN + 1                                      MD029834
 
     C**********         IF        MATCH = 1                                                MD029834
     C                   IF        MATCH = 0                                                MD029834
     C                             AND (DPCC <> *BLANKS                                     MD029834
     C                             OR   DPCD <> *BLANKS)                                    MD029834
     C                   EXSR      FINDMATCH
     C                   ELSE                                                               MD029834
     C                   IF        MATCH = 0                                                MD029834
     C                   EVAL      MATCH = 1                                                MD029834
     C                   ENDIF                                                              MD029834
     C                   EVAL      WFilterDesc = FilterDesc                                 MD029834
     C                   EVAL      WFCDESC = FCDESC                                         MD029834
     C                   EVAL      WFilterDesc = %XLATE(Up:Lo:WFilterDesc)                  MD029834
     C                   EVAL      WFCDESC = %XLATE(Up:Lo:WFCDESC)                          MD029834
                                                                                            MD029834
     C                   IF        DPCD <> *BLANKS AND                                      MD029834
     C                             %scan(%trim(WFilterDesc):WFCDESC:1) = 0                  MD029834
     C                   GOTO      ReadNext                                                 MD029834
     C                   ENDIF                                                              MD029834
     C                   ENDIF
     C
     C                   EVAL      DCCODE = FCCODE
     C                   EVAL      DCDESC = FCDESC
     C                   IF        NoRecSts = *OFF                                          MD033128
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000200S0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      SflRRN = SflRRN + 1                                      MD029834
     C                   ENDIF                                                              MD033128
 
     C     ReadNext      TAG
     C                   READ      SDFATCD0
     C                   ENDDO
      *
      ** Only inactive/deleted records exist
      *
     C**********         IF        SflRRN < 1                                               MD033128
     C                   IF        SflRRN = 1                                               MD033128
     C                             AND FCRECI = '*'                                         MD033128
     C                   EXSR      NoRecords
     C                   ENDIF
 
      *
      ** Display subfile / Prompt user selection
      *
     C                   IF        WMatchFound = 'N'                                        MD029834
     C                             AND (DPCC <> *BLANKS                                     MD029834
     C                             OR   DPCD <> *BLANKS)                                    MD029834
     C                   EVAL      SflRRN = 0                                               MD029834
     C                   EVAL      *IN80 = *ON                                              MD029834
     C                   EVAL      *IN79 = *OFF                                             MD029834
     C                   WRITE     SD000200C0                                               MD029834
     C                   EVAL      *IN80 = *OFF                                             MD029834
     C                   EXSR      NoRecords                                                MD029834
     C                   EVAL      FilterCode = *BLANKS                                     MD029834
     C**********         EVAL      DPCC = *BLANKS                                  MD029834 MD034079
     C                   EVAL      FilterDesc = *BLANKS                                     MD029834
     C**********         EVAL      DPCD = *BLANKS                                  MD029834 MD034079
     C                   EVAL      *IN79 = '1'                                              MD034079
                                                                                            MD029834
      ** Clear program message queue                                                        MD029834
     C                   CALL      'ZA0250'                                                 MD029834
                                                                                            MD029834
     C**********         GOTO      START                                           MD029834 MD034079
                                                                                            MD029834
     C                   ELSE                                                               MD029834
     C                   EVAL      *IN82 = *ON
     C                   WRITE     SD000200F0
     C                   EXFMT     SD000200C0
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
     C                   ENDIF                                                              MD029834
      *
     C     BuildSflE     ENDSR
      *
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
     C**********         EVAL      *IN79 = *OFF                                             MD029834
     C**********         EVAL      SflRRN = SflRRN + 1                                      MD029834
     C**********         WRITE     SD000200S0                                               MD029834
      *
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0307'     ZAMSID
     C                   EXSR      ZASNMS
     C                   EVAL      NoRecSts = *ON                                           MD033128
     C                   WRITE     SD000200F1                                               MD033128
     C                   WRITE     #MSGCTL
     C                   EVAL      *IN79 = *OFF                                             MD029834
     C                   EVAL      SflRRN = SflRRN + 1                                      MD029834
     C                   WRITE     SD000200S0                                               MD029834
     C                   EXFMT     SD000200C0                                               MD029834
     C                   ENDSR
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
      *                  // Check if delete is allowed
     C                   IF        DCACTN = 'D' and BJSUC = 'Y'
      *
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0313'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C
     C                   EVAL      Err = 1
 
     C                   ENDIF
     C
     C                   OTHER
                         // DDACTN is not a valid option
      *
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
     C                   EVAL      *IN34 = *ON                                              MD029834
     C                   EVAL      *IN33 = *ON                                              MD029834
     C                   IF        FrsPass = ' '                                            MD029834
     C                   EVAL      MATCH = 1                                                MD029834
     C                   EVAL      FrsPass = '1'                                            MD029834
     C                   ENDIF                                                              MD029834
 
     C                   ENDSL
 
      *
     C     ValidateOptE  ENDSR
      *
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
      *
     C                   IF        FilterCode <> *BLANKS
 
      ** Check Code Filter Match
     C**********         IF        %trim(FilterCode) =                                      MD033546
     C**********                    %subst(FCCODE:1:%len(%trim(FilterCode)))                MD033546
     C**********                   and Match = 1                                            MD033546
     C**********         IF        FilterCode = FCCODE                             MD033546 MD036917
     C                   IF        FilterCode <= FCCODE                                     MD036917
     C                   EVAL      WMatchFound = 'Y'                                        MD029834
     C                   EVAL      MATCH = SflRRN
     C**********         EVAL      FilterCode = *BLANKS                                     MD033546
     C**********         EVAL      FilterDesc = *BLANKS                                     MD033546
     C                   ENDIF
 
     C                   ELSEIF    FilterDesc <> *BLANKS
                                                                                            MD029834
     C                   EVAL      WWDPCD = FilterDesc                                      MD029834
     C                   EVAL      WFilterDesc = FilterDesc                                 MD029834
     C                   EVAL      WFCDESC = FCDESC                                         MD029834
     C                   EVAL      WFilterDesc = %XLATE(Up:Lo:WFilterDesc)                  MD029834
     C                   EVAL      WFCDESC = %XLATE(Up:Lo:WFCDESC)                          MD029834
                                                                                            MD029834
      ** Check Description Filter Match
     C**********         IF        %scan(%trim(FilterDesc):FCDESC:1) > 0                    MD029834
     C                   IF        %scan(%trim(WFilterDesc):WFCDESC:1) > 0                  MD029834
     C                   EVAL      WMatchFound = 'Y'                                        MD029834
     C                   EVAL      MATCH = SflRRN
     C**********         EVAL      FilterDesc = *BLANKS                                     MD029834
     C                   ENDIF
 
     C                   ENDIF
      *
      *
     C     FindMatchE    ENDSR
      *
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
      *
     C                   CALL      'SD000201'
     C                   PARM                    DetActn
     C                   PARM      Mode          DetMode
     C                   PARM      *Blanks       DetRetCode
     C                   PARM                    DetClsCode
 
     C                   IF        DetRetCode <> *Blanks
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        DetActn = 'I'                                            MD033128
     C                   EVAL      NoRecSts = *OFF                                          MD033128
     C                   ENDIF                                                              MD033128
     C                   EVAL      DetActn = *Blanks
     C                   EVAL      DetMode = *Blanks
     C                   EVAL      DetRetCode = *Blanks
     C                   EVAL      DetClsCode = *Blanks
     C                   EVAL      DCACTN = *BLANKS                                         MD029834
     C                   EVAL      MATCH = SflRRN                                           MD029834
     C                   SETON                                        35                    MD029834
      *
     C     DetPgmE       ENDSR
      *
      /EJECT
      *
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C                   IF        ZAMSGF = *BLANKS
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   END
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM                          Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZAMSID                         Message Id
     C                   PARM                    ZAMSGF                         Message file
     C                   PARM                    ZAMSDA                         Message data
     C                   PARM                    ZAMSTP                         Message type
      *
     C                   MOVEL     *BLANKS       ZAMSGF
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAPGRL
      *
     C                   ENDSR
      *
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
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
