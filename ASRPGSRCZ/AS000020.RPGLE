     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Historic Market Data Report Prompt')          *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS000020 - Midas AS Historic Market Data Report Prompt       *
      *                                                               *
      *  Function:  This program controls screen AS000020DF which     *
      *             is used to specify a Hedge Linkage ID for         *
      *             Historic Market Data report. It will return a     *
      *             specific Hedge Linkage ID if one is input         *
      *             else, if blank, the string 'ALL   ' will be       *
      *             returned to the calling program.                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS007             Date 26Apr04               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CAS007 - Hedge Accounting Control                            *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FAS000020DFCF   E             WORKSTN
      ** Prompt Display File
 
     FASHGLKL1  IF   E           K DISK
      ** AS Hedge Linkage File
 
     FSDHGSTL1  IF   E           K DISK
      ** SD Hedge Strategy File
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work variables
     D WHedgeID        S              6S 0
     D WErr            S              1A
 
      ** Entry Parameter List
     D PSeq            S              5A
     D PLev            S              1A
     D Pent            S              3A
     D PParm           S            100A
     D PAct            S              1A
     D PCmd            S              1A
 
      ** Parameters for Y2SNMGC
     D PZPGMQ          S             10A
     D PZPGRL          S              5A
     D PZMSID          S              7A
     D PZMSGF          S             10A
     D PZMSDA          S            132A
     D PZMSTP          S              7A
 
      ** Parameters for ZALIGN
     D PZAlignOk       S              1A
     D PZFIELD         S             16A
     D PZADEC          S              1  0
     D PZADIG          S              2  0
 
      ** Parameters for Standard Access Objects
     D PRtCd           S              7A
     D POption         S              7A
     D PSARD           S              6A                                                      CAS007
 
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
 
     C                   WRITE     AS000020C0
     C                   EXFMT     AS000020F0
 
      ** Clear Message Subfile.
 
     C                   CALL      'Y2CLMSC'
     C                   PARM                    PZPGMQ
     C                   PARM      '*SAME'       PZPGRL
 
      ** Clear Error Indicator.
 
     C                   EVAL      WERR = 'N'
     C                   EVAL      *IN20 = *OFF
 
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
 
      ** Validate the Hedge Linkage ID entered.
 
     C                   OTHER
     C                   EXSR      SrValHedge
 
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
 
     C                   WRITE     AS000020C0
     C                   EXFMT     AS000020F0
 
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
 
      ** If F6 is pressed at this point, we load the specified
      ** Hedge Linkage ID into the 'Parameters' parameter, ready for
      ** return to FCC0201.
 
     C                   WHEN      *INKF = *ON
     C                   MOVEL     #0HEDI        PPARM
 
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
     C                   MOVEL     'ASM0149'     PZMSID
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
     C                   MOVEL     'ASM0150'     PZMSID
     C                   EXSR      ZASNMS
     C                   EVAL      WERR = 'Y'
     C                   EVAL      *IN20 = *ON
 
      ** Hedge Linkage should be live or expired.
 
     C                   ELSE
     C                   IF        FSRECI <> 'D' AND FSRECI <> 'X'
     C                   MOVEL     'ASM0157'     PZMSID
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
     C                   MOVEL     'ASM0151'     PZMSID
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
 
     C                   MOVE      'ALL   '      #0HEDI
 
     C                   ENDIF
 
      ** If no errors, set on *IN13 to protect the hedge linkage ID
      ** field, show the F6 literal, and enable F6 processing.
 
     C                   IF        WERR <> 'Y'
     C                   EVAL      *IN13 = *ON
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Process error message                               *
      *                                                               *
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PZPGMQ
     C                   PARM                    PZPGRL
     C                   PARM                    PZMSID
     C                   PARM                    PZMSGF
     C                   PARM                    PZMSDA
     C                   PARM                    PZMSTP
 
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
 
     C                   EVAL      PZPGMQ = PSProcName
     C                   EVAL      PZMSGF = 'SDUSRMSG  '
 
      ** Use access program to read bank details file
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtCd <> *BLANKS
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
     C                   PARM      *BLANKS       PRTCD                                        CAS007
     C                   PARM      '*VERIFY'     POPTION                                      CAS007
     C                   PARM      'CAS007'      PSARD                                        CAS007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS007
                                                                                              CAS007
      ** If CAS007 is not installed, exit from the program                                    CAS007
                                                                                              CAS007
     C                   IF        PRTCD = '*NRF   '                                          CAS007
     C                   EVAL      *INLR = *ON                                                CAS007
     C                   RETURN                                                               CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS007
      ** Database error                                                                       CAS007
                                                                                              CAS007
     C                   IF        PRTCD <> *BLANKS  AND                                      CAS007
     C                             PRTCD <> '*NRF   '                                         CAS007
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
(c) Finastra International Limited 2003
