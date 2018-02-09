     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE file to screen format')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLBITPCVT - Batch Item Conversion:                           *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a Batch Item   *
      *             from file to screen format                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL135A            Date 10Jul13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CAP207             Date 10Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246418             Date 20Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BG9185             Date 08Nov05               *
      *                 BUG5923            Date 21Feb05               *
      *                 BUG5208            Date 15Dec04               *
      *                 BUG2948            Date 03Jun04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 12Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL135A - Accounting Rules Process                           *
      *            Added hooks: CGL135_047, CGL135_048, CGL135_049,   *
      *                         CGL135_050                            *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246418 - CGL013 changes for Midas Plus                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BG9185 - Correction to CGL029.                               *
      *  BUG5923- Move narrative code (BTNVCD) to screen field        *
      *           if description(BTNRDC) is blanks.                   *
      *  BUG5208 - When Retail numbers are not used, still need the   *
      *           full account reference for retail accounts.         *
      *  BUG2948 - Different branch code item accepted even if        *
      *           multiple branch indicator is set to 'N'. (recompile)*
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - MidasPlus Changes                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
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
 
     D BITPFilFmt    E DS                  EXTNAME(GLJENPPD)
      ** Batch Header Transaction Details in File Format
      *                                                                                       246418
     D BITPXFilFmt   E DS                  EXTNAME(GLJENXPD)                                  246418
      ** JE Additional Info Data for CGL013 - File format of GLJENXPD                         246418
 
     D BITPDets      E DS                  EXTNAME(GLBITPPD)
      *                                                                                       246418
      ** JE Additional Info Data for CGL013 - Screen format of GLBITPXPD                      246418
     D BITPXScnFmt   E DS                  EXTNAME(GLBITPXPD)                                 246418
      *                                                                                       246418
     D*QQACC1********E                     EXTFLD(QQACCD)                              CGL029 BG9185
      ** Batch Header Transaction Details in Screen Format
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Retail Details                                                                      BUG5208
     D SDRETL        E DS                  EXTNAME(SDRETLPD)                                 BUG5208
     D QQACC2        E                     EXTFLD(QQACCD)                                    BUG5208
                                                                                             BUG5208
     D/COPY OFCPYSRCZ,CGL135_047                                                             CGL135A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Blank outputs
     C                   MOVEL     *BLANK        BITPDets
 
      ** Set screen fields
     C                   EXSR      SCREEN
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      * Account Details
     C     BTACTY        IFEQ      'R'
     C     BMRANR        ANDEQ     'Y'                                                       BUG5208
      *
     C     BTRACN        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDACID
     C                   ELSE
     C                   MOVE      BTRACN        DDACID
     C                   ENDIF
      *
     C                   EVAL      DDCYCD = *BLANKS
     C                   EVAL      DDIBCA = *BLANKS
     C                   EVAL      DDACSN = *BLANKS
     C                   EVAL      DDIBCA = *BLANKS
      *
     C                   ELSE
     C                   EVAL      DDACID = BTCUST
     C                   EVAL      DDCYCD = BTCYCD
     C                   EVAL      DDACCD = BTACCD
     C                   EVAL      DDACSN = BTACSN
     C                   EVAL      DDIBCA = BTIBCA
     C                   ENDIF
 
      * Posting Amount
 
     C     BTPTAM        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDPTAM
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BTCYCD        @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      RetCodeIn = '*ERROR '
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BTPTAM        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDPTAM
     C                   ENDIF
 
      * DR/CR
     C                   EVAL      DDDCIN = BTDCIN
 
      * Narrative
     C                   IF        BTNVCD = *BLANKS                                          BUG5923
     C                   EVAL      DDNARR = BTNRDC
     C                   ELSE                                                                BUG5923
     C                   EVAL      DDNARR = BTNVCD                                           BUG5923
     C                   ENDIF                                                               BUG5923
 
      * Transaction Type
     C                   EVAL      DDTRTY = BTTRTY
 
      * Transaction Sub-Type
     C                   EVAL      DDTSTY = BTTSTY
 
      * Value Date
     C                   IF        BTVLDT = *ZERO
     C                   EVAL      DDVLDT = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = BTVLDT
     C                   EXSR      ZDATE2
     C                   EVAL      DDVLDT = *BLANKS
     C                   MOVEL     ZDATE         DDVLDT
     C                   ENDIF
 
      * Cheque Number
     C                   EVAL      DDCQNB = BTCQNB
 
      * Swift Reference
     C                   EVAL      DDSWCR = BTSWCR
 
      * Profit Centre
     C                   EVAL      DDPRCN = BTPRCN
 
      * Associated Customer
     C                   EVAL      DDACNB = BTACNB
 
      * Book Code
     C                   EVAL      DDBKCD = BTBKCD
 
      * Reverse/Void Indicator
     C                   EVAL      DDRVDI = BTRVDI
 
      * No of items
     C     BTNITM        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDNITM
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BTNITM        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDNITM
     C                   ENDIF
 
      * Retail Indicator Override
     C                   EVAL      DDRINO = BTRINO
 
      * Original Currency
     C                   EVAL      DDOCCY = BTOCCY
 
      * Original Amount
     C     BTOAMT        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDOAMT
     C                   ELSE
     C                   CALL      'AOCURRR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BTOCCY        @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      RetCodeIn = '*ERROR '
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 902
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BTOAMT        ZFIELD
     C                   MOVE      A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDOAMT
     C                   ENDIF
 
      * Batch Header Number
     C                   EVAL      DDBTNB = BTBTNB
 
      * Batch Item Number
     C     BTBINB        IFEQ      *ZERO
     C                   MOVEL     *BLANKS       DDBINB
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      BTBINB        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDBINB
     C                   ENDIF
      *                                                                                       246418
     C                   IF        CGL013 = 'Y'                                               246418
     C                   EVAL      DDADI1 = BAADI1                                            246418
     C                   EVAL      DDADI2 = BAADI2                                            246418
     C                   EVAL      DDADI3 = BAADI3                                            246418
     C                   EVAL      DDADI4 = BAADI4                                            246418
     C                   EVAL      DDADI5 = BAADI5                                            246418
     C                   EVAL      DDADI6 = BAADI6                                            246418
     C                   EVAL      DDAERI = BAAERI                                            246418
     C                   ENDIF                                                                246418
      *                                                                                       246418
     C/COPY OFCPYSRCZ,CGL135_048                                                             CGL135A
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * Input Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Batch Header Details File Format
     C                   PARM                    BITPFilFmt
      *                                                                                       246418
      * Batch Header Details File Format                                                      246418
     C                   PARM                    BITPXFilFmt                                  246418
      *                                                                                       246418
      ** MT94x Messages Generation                                                            246418
     C                   PARM                    CGL013            1                          246418
      *
      * Output Parameters
 
      * Batch Header Details Screen Format
     C                   PARM                    BITPDets
 
      * Batch Item Additional Information Screen Format                                       246418
     C                   PARM                    BITPXScnFmt                                  246418
     C/COPY OFCPYSRCZ,CGL135_049                                                             CGL135A
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'GLBITPCVT'
 
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access RETAIL account details                                                       BUG5208
      *                                                                                      BUG5208
     C                   CALL      'AORETLR0'                                                BUG5208
     C                   PARM      *BLANKS       @RTCD                                       BUG5208
     C                   PARM      '*FIRST  '    @OPTN                                       BUG5208
     C     SDRETL        PARM      SDRETL        DSSDY                                       BUG5208
      *                                                                                      BUG5208
      * Database Error                                                                       BUG5208
      *                                                                                      BUG5208
     C                   IF        @RTCD <> *BLANK                                           BUG5208
     C                   EVAL      DBKEY = @OPTN                                             BUG5208
     C                   EVAL      DBFILE = 'SDRETLPD'                                       BUG5208
     C                   EVAL      DBASE = 903                                               BUG5208
     C                   EXSR      *PSSR                                                     BUG5208
     C                   ENDIF                                                               BUG5208
      *                                                                                      BUG5208
     C/COPY OFCPYSRCZ,CGL135_050                                                             CGL135A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
