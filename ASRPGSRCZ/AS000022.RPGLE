     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Regression Analysis I/C Prompt Program')
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS000022 - Midas AS Regression Analysis I/C Prompt           *
      *                                                               *
      *  Function:  This program controls screen AS000022DF which     *
      *             is used to specify a Hedge Linkage ID for         *
      *             Regression Analysis. It will return a specific    *
      *             Hedge Linkage ID if one is inputted else, if      *
      *             blank, the string 'ALL   ' will be returned to    *
      *             the calling program.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CAS010             Date 09Feb05               *
      *                 CAS007             Date 26Apr04               *
      *                 225949             Date 30Mar04               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  CAS007 - Hedge Accounting Control                            *
      *  225949 - User can now choose to print hedge linkages for a   *
      *           certain branch.  In the prompt screen, user can     *
      *           input either Hedge Linkage Id or Branch.            *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Prompt Display File
     FAS000022DFCF   E             WORKSTN
 
      ** AS Hedge Linkage File
     FASHGLKL1  IF   E           K DISK
 
      ** SD Hedge Strategy File
     FSDHGSTL1  IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CAS007
      ** External DS for SC Switchable Features                                               CAS007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS007
                                                                                              225949
      ** External Data Structures for Branch Details                                          225949
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  225949
                                                                                              225949
      ** DS for Access Programs: Long Data Structure                                          225949
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     225949
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work variables
     D WHedgeID        S              6S 0
     D WErr            S              1
 
      ** Entry Parameter List
     D PSeq            S              5A
     D PLev            S              1A
     D Pent            S              3A
     D PParm           S            100A
     D PAct            S              1A
     D PCmd            S              1A
 
      ** Parameters for Y2SNMGC
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
 
      ** Parameters for ZALIGN
     D PZAlignOk       S              1
     D PZFIELD         S             16
     D PZADEC          S              1  0
     D PZADIG          S              2  0
                                                                                              225949
      ** Parameters for Access Objects                                                        225949
     D Prtcd           S              7                                                       225949
     D POptn           S              7                                                       225949
     D PSARD           S              6                                                       CAS007
     D PBrca           S              3                                                       225949
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Control Initial Display.
 
     C                   DOW       *IN13 = *OFF
 
     C                   EVAL      *INKL = *OFF
 
      ** Do while not F3, not F12, and not in 'Confirm Report' mode.
 
     C                   DOW       *INKC = *OFF AND
     C                             *INKL = *OFF AND
     C                             *IN13 = *OFF
 
     C                   WRITE     AS000022C0
     C                   EXFMT     AS000022F0
 
      ** Clear Message Subfile.
 
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
 
      ** Clear Error Indicator.
 
     C                   EVAL      WERR = 'N'
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF                                               225949
 
      ** If F3 is pressed at this point, return to FCC0201 with PCMD
      ** set to 'E' to end the transaction.
 
     C                   SELECT
     C                   WHEN      *INKC = *ON
     C                   MOVE      'E'           PCMD
 
      ** If F12 is pressed at this point, return to FCC0201 with PCMD
      ** set to 'F', so that the previous screen is displayed.
 
     C                   WHEN      *INKL = *ON
     C                   MOVE      'F'           PCMD
 
      ** If F5 is pressed at this point, clear the Hedge Linkage ID
      ** field on the screen, and start again.
 
     C                   WHEN      *INKE = *ON
     C                   MOVE      *BLANKS       #0HEDI
     C                   MOVE      *BLANKS       #0BRCA                                       225949
 
      ** Validate branch first, then                                                          225949
      ** Validate the Hedge Linkage ID entered.
 
     C                   OTHER
     C                   EXSR      SrBranch                                                   225949
     C                   IF        WERR = 'N'                                                 225949
     C                   EXSR      SrValHedge
     C                   ENDIF                                                                225949
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   IF        *IN13 = *ON
     C                   EXSR      SrConfirm
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
      ** Return Control to FCC0201.
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      *                                                               *
      *  SrConfirm - Process 'Confirmation' screen                    *
      *                                                               *
      *****************************************************************
     C     SrConfirm     BEGSR
 
      ** If validation is successful, then *IN13 will be set on,
      ** protecting all the fields, and enabling F6. The screen is
      ** displayed again at this point.
 
     C                   DOW       *INKC = *OFF AND
     C                             *INKF = *OFF AND
     C                             *INKL = *OFF
 
     C                   WRITE     AS000022C0
     C                   EXFMT     AS000022F0
 
      ** If F3 is pressed at this point, return to FCC0201 with PCMD
      ** set to 'E' to end the transaction.
 
     C                   SELECT
 
     C                   WHEN      *INKC = *ON
     C                   MOVE      'E'           PCMD
 
      ** If F12 or F5 is pressed at this point, we come out of
      ** 'Confirm Update' mode, and start again.
 
     C                   WHEN      *INKL = *ON
     C                   MOVE      '0'           *IN13
     C                   IF        #0HEDI = 'ALL   '
     C                   MOVE      *BLANKS       #0HEDI
     C                   ENDIF
     C                   MOVE      *BLANKS       #0BRCA                                       225949
 
      ** If F6 is pressed at this point, we load the specified
      ** Hedge Linkage ID into the 'Parameters' parameter, ready for
      ** return to FCC0201.
 
     C                   WHEN      *INKF = *ON
                                                                                              225949
     C                   IF        #0HEDI = *BLANKS                                           225949
     C                   MOVEL     'ALL   '      #0HEDI                                       225949
     C                   ENDIF                                                                225949
                                                                                              225949
     C                   MOVEL     #0HEDI        PPARM
     C                   MOVEL     'B'           PLev                                         225949
     C                   MOVEL     #0BRCA        PEnt                                         225949
 
     C                   ENDSL
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValHedge - Validate Hedge Linkage ID                       *
      *                                                               *
      *****************************************************************
     C     SrValHedge    BEGSR
 
      ** If not blank, validate Hedge Linkage ID.
 
     C                   IF        #0HEDI <> *BLANKS
 
      ** Hedge Linkage ID should be a 6 digit number.
 
     C                   EVAL      PZADEC = 0
     C                   EVAL      PZADIG = 6
     C                   EVAL      PZFIELD = *BLANKS
     C                   EVAL      PZFIELD = #0HEDI
     C                   EXSR      SRZAlign
 
     C                   IF        PZAlignOk = 'N'
     C                   MOVEL     'ASM0149'     ZAMSID
     C                   EXSR      ZASNMS
     C                   EVAL      WERR = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
 
      ** Hedge Linkage ID should exist.
 
     C                   IF        WERR = 'N'
     C                   MOVE      PZFIELD       #0HEDI
     C                   MOVE      #0HEDI        WHedgeID
     C     WHedgeID      CHAIN     ASHGLKL1
     C                   IF        NOT %FOUND(ASHGLKL1)
     C                   MOVEL     'ASM0150'     ZAMSID
     C                   EXSR      ZASNMS
     C                   EVAL      WERR = 'Y'
     C                   EVAL      *IN20 = *ON
 
      ** Hedge Linkage should not be deleted, expired, matured, or discontinued.
 
     C                   ELSE
     C                   IF        FSRECI = '*' OR FSRECI = 'E' OR
     C                             FSRECI = 'M' OR FSRECI = 'X'
     C                   MOVEL     'ASM0152'     ZAMSID
     C                   EXSR      ZASNMS
     C                   EVAL      WERR = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Hedge Linkage should have assessment method equal to 'R'.
 
     C                   IF        WERR = 'N'
     C     FSHGST        CHAIN     SDHGSTL1
     C                   IF        %FOUND(SDHGSTL1)
     C                   IF        FSMEFF <> 'R'
     C                   MOVEL     'ASM0151'     ZAMSID
     C                   EXSR      ZASNMS
     C                   EVAL      WERR = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
     C                   ELSE
 
      ** Process database error.
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDHGSTL1'
     C                   EVAL      DBKEY  =  FSHGST
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPROC =  'SrValHedge'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
 
      ** Process all hedge linkages.
 
     C                   IF        #0BRCA = *BLANKS                                           225949
     C                   MOVE      'ALL   '      #0HEDI
     C                   ENDIF                                                                225949
 
     C                   ENDIF
 
      ** If no errors, set on *IN13 to protect the hedge linkage ID
      ** field, show the F6 literal, and enable F6 processing.
 
     C                   IF        WERR <> 'Y'
     C                   EVAL      *IN13 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  225949
      *****************************************************************                       225949
      *                                                               *                       225949
      *  SrBranch - Validate Branch                                   *                       225949
      *                                                               *                       225949
      *****************************************************************                       225949
     C     SrBranch      BEGSR                                                                225949
                                                                                              225949
      ** If not blank, validate Branch                                                        225949
                                                                                              225949
     C                   IF        #0BRCA <> *BLANKS                                          225949
                                                                                              225949
      ** Error if Hedge id is not blank.                                                      225949
                                                                                              225949
     C                   IF        #0HEDI <> *BLANKS                                          225949
     C                   MOVEL     'ASM0163'     ZAMSID                                       225949
     C                   EXSR      ZASNMS                                                     225949
     C                   EVAL      WERR = 'Y'                                                 225949
     C                   EVAL      *IN20 = *ON                                                225949
     C                   EVAL      *IN21 = *ON                                                225949
     C                   ENDIF                                                                225949
                                                                                              225949
      ** Check if Branch code exists in SDBRCHPD.                                             225949
                                                                                              225949
     C                   IF        WERR = 'N'                                                 225949
                                                                                              225949
     C**********         CALL      'AOBRCHR0'                                          225949 CAS010
     C                   CALL      'AOBRCHR1'                                                 CAS010
     C                   PARM      *BLANKS       Prtcd                                        225949
     C                   PARM      '*KEY   '     POptn                                        225949
     C                   PARM      #0BRCA        PBrca                                        225949
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        225949
                                                                                              225949
     C     Prtcd         IFNE      *BLANKS                                                    225949
     C                   MOVEL     'USR0719'     ZAMSID                                       225949
     C                   EXSR      ZASNMS                                                     225949
     C                   EVAL      WERR = 'Y'                                                 225949
     C                   EVAL      *IN21 = *ON                                                225949
     C                   ELSE                                                                 225949
     C                   MOVEL     A8BRCD        #0BRCA                                       225949
     C                   ENDIF                                                                225949
                                                                                              225949
     C                   ENDIF                                                                225949
     C                   ENDIF                                                                225949
                                                                                              225949
     C                   ENDSR                                                                225949
      *****************************************************************                       225949
                                                                                              225949
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Process error message                               *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign  - Align and validate numeric field                 *
      *                                                               *
      *****************************************************************
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       PZAlignOk
     C                   PARM                    PZFIELD
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameter List
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLev
     C                   PARM                    PEnt
     C                   PARM                    PParm
     C                   PARM                    PAct
     C                   PARM                    PCmd
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA
 
     C                   EVAL      #0PGM = PSProcName
     C                   EVAL      #0WSID = PSProcMod
     C                   EVAL      #0USER = PSUser
 
     C                   EVAL      ZAPGMQ = PSProcName
     C                   EVAL      ZAMSGF = 'SDUSRMSG  '
 
      ** Use access program to read bank details file
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*CALL'
     C                   EVAL      DBASE  =  1
     C                   EVAL      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS007
      ** Check if CAS007 is installed                                                         CAS007
                                                                                              CAS007
     C                   CALL      'AOSARDR0'                                                 CAS007
     C                   PARM      *BLANKS       @RTCD                                        CAS007
     C                   PARM      '*VERIFY'     @OPTN                                        CAS007
     C                   PARM      'CAS007'      PSARD                                        CAS007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS007
                                                                                              CAS007
      ** If CAS007 is not installed, exit from the program                                    CAS007
                                                                                              CAS007
     C                   IF        @RTCD = '*NRF   '                                          CAS007
     C                   EVAL      *INLR = *ON                                                CAS007
     C                   RETURN                                                               CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS007
      ** Database error                                                                       CAS007
                                                                                              CAS007
     C                   IF        @RTCD <> *BLANKS  AND                                      CAS007
     C                             @RTCD <> '*NRF   '                                         CAS007
     C                   EVAL      DBKEY = PSARD                                              CAS007
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS007
     C                   EVAL      DBASE  =  3                                                CAS007
     C                   EXSR      *PSSR                                                      CAS007
     C                   ENDIF                                                                CAS007
 
      ** Obtain Midas Run Date
 
     C                   EVAL      #0RUND = BJMRDT
 
     C                   ENDSR
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2003
