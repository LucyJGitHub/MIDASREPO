     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade SWIFT details defaulting')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETSWFTDFT - SECURITIES TRADE SWIFT DETAILS DEFAULTING       *
      *                                                               *
      *  Function  - This program defaults the SWIFT/Settlement       *
      *              Instructions for Securites Trades Input SCREENS. *
      *              It is based on code from original Midas program  *
      *              SE1805, subroutines SRINZA & SRINZB.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR1040921          Date 07Feb13               *
      *  Prev Amend No. 263512             Date 12Jan10               *
      *                 AR580916           Date 22Jul10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247327             Date 03May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 212669             Date 07Feb03               *
      *                 CSD027B            Date 28Jun06               *
      *                 214006             Date 07Feb03               *
      *                 BUG3122            Date 17Jul04               *
      *                 225421   (BUG1356) Date 03Mar04               *
      *                 223804             Date 14Dec03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210782             Date 18Oct02               *
      *                 208195             Date 08Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205208             Date 15May02               *
      *                 CSE034             Date 22Apr02               *
      *                 201233             Date 20Dec01               *
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 175216             Date 12Sep00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 03Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1040921 - Time of Trade will only be defaulted when        *
      *              passed value is blank. (Child:AR1040922)         *
      *  263512 - Settlement request being reverted to 'Y' when the   *
      *           user unticked the check box in the Java screen.     *
      *           Patterned fix after 223804 for the B_DDGMES.        *
      *  AR580916 - Customer/CParty Indicator always defaulted        *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247327 - Incorrect defaulting of Safekeeping Account field.  *
      *           Re-instate and correct the defaulting process       *
      *           introduced by core fix 205208. This fix will also   *
      *           resolve the Dberr caused by core fix 205208.        *
      *  212669 - Field 'Safekeeping Accounts' should not be defaulted*
      *           with value from STDSED (only to be used for MG0565) *
      *  CSD027B- Further Customer Number changes.                    *
      *  214006 - No //XE and //XC (with ISO15022)                    *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  225421 - After Swift 2002 changes ISO15022 indicator         *
      *           should always set to 'Y'.                           *
      *  223804 - Confirmation request being cleared                  *
      *  210782 - Confirmation request did not default                *
      *  208195 - Database Error occured when client number is blank. *
      *  205208 - Safe keeping account incorrectly defaulting.        *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  201233 - If message is unroutable, settlement of message     *
      *           request cannot be a 'Y'.                            *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *  CSE022 - Depository Definition Enhancement                   *
      *  175216 - Addtional field required for SWIFT 98.              *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
      /EJECT
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Trade Details, SWIFT (A screen)
     D A_TrSwft      E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A_)
      * Trade Details, SWIFT (B screen)
     D B_TrSwft      E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B_)
 
 
     D TDVD            S              5P 0
     D*TCNR*****       S              6S 0                                                   CSD027B
     D*DELF*****       S              6S 0                                                   CSD027B
     D*DELT*****       S              6S 0                                                   CSD027B
     D TCNR            S              6A                                                     CSD027B
     D DELF            S              6A                                                     CSD027B
     D DELT            S              6A                                                     CSD027B
 
 
 
     D EUCL1           S              1    DIM(6)
     D EUCL2           S              1    DIM(6)
     D ROU             S              1    DIM(12)
     D POType          S              1A                                                      CSE028
     D PRetCode        S                   LIKE(ReturnCode)                                   CSE028
 
      ** DS for customer/book standard settlement instruction                                 CSE028
      **  to be passed to SESSIR0                                                             CSE028
     D PCBStd        E DS                  EXTNAME(STDSED)                                    CSE028
     D                                     Occurs(2)                                          CSE028
                                                                                              CSE028
      ** Data structure for standard additional settlement details                            CSE028
      ** for customer/book to be passed to SESSIR0                                            CSE028
     D PCBStdAd      E DS                  EXTNAME(STDADSED)                                  CSE028
     D                                     Occurs(8)                                          CSE028
                                                                                              CSE028
      ** DS for trade purchase                                                                CSE028
     D PTradeP       E DS                  EXTNAME(STDADSED)                                  CSE028
     D                                     Prefix(TP:2)                                       CSE028
                                                                                              CSE028
      ** DS for trade sale                                                                    CSE028
     D PTradeS       E DS                  EXTNAME(STDADSED)                                  CSE028
     D                                     Prefix(TS:2)                                       CSE028
 
      * EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      * EXTERNAL DS FOR SECURITIES CUSTOMER DETAILS
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** External DS for SAR Details                                                          CSE028
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE028
     D WLCD          E                     EXTFLD(LCD)                                        CSE028
                                                                                              CSE028
      ** Second Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  247327
      *                                                                                       247327
      ** External DS for Branch Details                                                       247327
      *                                                                                       247327
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * INITIAL FILE ACCESSES ...
      *
     C                   EXSR      INIT
      *
      ** Clear output fields
      *
     C     Screen        IFEQ      'A'
     C***********        CLEAR                   A_TrSwft                                     223804
     C                   CLEAR                   A_DDROUS
     C                   CLEAR                   A_DDROTS
     C                   CLEAR                   A_DDROUC
     C                   CLEAR                   A_DDROTC
     C                   ELSE
     C***********        CLEAR                   B_TrSwft                                     223804
     C                   CLEAR                   B_DDROUS
     C                   CLEAR                   B_DDROTS
     C                   CLEAR                   B_DDROUC
     C                   CLEAR                   B_DDROTC
     C                   ENDIF
      *                                                                                       CSE028
      ** If CSE028 is on, call SESSIR0 for default of MT5xx information                       CSE028
      *                                                                                       CSE028
     C     CSE028        IFEQ      'Y'                                                        CSE028
      *                                                                                       CSE028
     C**********         CALLB     'SESSIR0'                                           CSE028 210782
     C                   CALL      'SESSIR0'                                                  210782
     C                   PARM      'D'           POType                                       CSE028
     C                   PARM                    DDBRCD                                       CSE028
     C                   PARM                    TCNR                                         CSE028
     C                   PARM                    DDBPBK                                       CSE028
     C                   PARM                    DDSETC                                       CSE028
     C                   PARM                    DDMRKT                                       CSE034
     C                   PARM                    InvType           3                          CSE028
     C                   PARM                    PortRef           4                          CSE028
     C                   PARM                    PCBStd                                       CSE028
     C                   PARM                    PCBStdAd                                     CSE028
     C                   PARM      *BLANKS       PRetCode                                     CSE028
      *                                                                                       CSE028
     C     PRetCode      IFNE      '*NRF '                                                    CSE028
     C     PRetCode      ANDNE     '*NCRF'                                                    CSE028
     C     2             OCCUR     PCBStd                                                     CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C                   SELECT                                                               CSE028
      *                                                                                       CSE028
     C     DDTDTP        WHENEQ    'TP'                                                       CSE028
     C                   DO                                                                   CSE028
     C     5             OCCUR     PCBStdAd                                                   CSE028
     C                   MOVE      PCBStdAd      PTradeP                                      CSE028
     C                   ENDDO                                                                CSE028
      *                                                                                       CSE028
     C     DDTDTP        WHENEQ    'TS'                                                       CSE028
     C                   DO                                                                   CSE028
     C     6             OCCUR     PCBStdAd                                                   CSE028
     C                   MOVE      PCBStdAd      PTradeS                                      CSE028
     C                   ENDDO                                                                CSE028
      *                                                                                       CSE028
     C                   ENDSL                                                                CSE028
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *
      ** Initialize screens A or B
      *
     C     Screen        IFEQ      'A'
     C                   EXSR      SRINZA
     C                   ELSE
     C                   EXSR      SRINZB
     C                   ENDIF
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINZA  - Routine to initialize screen fields with defaults. *
      *                                                               *
      *****************************************************************
     C     SRINZA        BEGSR
      **
      ** Network routing and addresses for settlements
      ** ---------------------------------------------
      **
     C     DDTDTP        IFEQ      'TP'
     C                   MOVE      DELT          Sndr_DEPOT        6
     C                   MOVE      DELT          Dest_DEPOT        6
     C                   ELSE
     C                   MOVE      DELF          Sndr_DEPOT
     C                   MOVE      DELF          Dest_DEPOT
     C                   END
      *
     C                   EXSR      SR1100
      *                                                                                       CSE028
     C     CSE028        IFEQ      'N'                                                        CSE028
     C                   MOVE      W_GME         A_DDGMES
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C                   MOVE      W_ROU         A_DDROUS
     C                   MOVE      W_ROT         A_DDROTS
      *
      ** Default Settlement request to N if backvaluation
      ** ------------------------------------------------
      *
     C     DDACTN        IFEQ      'I'
     C     TDVD          ANDLT     BJRDNB
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C                   MOVE      'N'           A_DDGMES
     C                   END
      *
      ** Settlement Message
      ** ------------------
      *
     C     CSW003        IFEQ      'Y'
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C     TCNR_CLAS     IFEQ      'S'
     C     DELT          ANDEQ     DELF
     C     TCNR_CLAS     OREQ      'D'
     C     DELT          ANDEQ     DELF
     C                   MOVE      'N'           A_DDGMES
     C                   ENDIF
     C                   ENDIF
      *                                                                                       201233
      ** Default settlement message to 'N' if destination is unroutable.                      201233
      *                                                                                       201233
     C     W_GME         IFEQ      'N'                                                        201233
     C                   MOVE      'N'           A_DDGMES                                     201233
     C                   ENDIF                                                                201233
      *
      ** Time of trade
      ** --------------
      *
     C                   IF        A_DDTRTT = *BLANKS                                      AR1040921
     C                   TIME                    WWTIME            6 0
     C                   MOVEL     WWTIME        A_DDTRTT
     C                   ENDIF                                                             AR1040921
      *
      ** Instructions type and sub-type
      ** ------------------------------
      *
     C     CSW003        IFEQ      'Y'
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C     DDTDTP        IFEQ      'TP'
      *
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVEL     '01'          A_DDINST
     C                   MOVE      'MATCH'       A_DDINSS
      *
     C     DDCLTY        WHENEQ    '2'
     C                   SELECT
     C     DELF_CLAS     WHENEQ    'C'
     C                   MOVEL     '03C'         A_DDINST
     C                   MOVE      'MATCH'       A_DDINSS
     C*****DELF_CLAS     WHENEQ    'K'                                                        CSE022
     C**********         MOVEL     '03K'         A_DDINST                                     CSE022
     C     DELF_CLAS     WHENEQ    'X'
     C     DELF_CLAS     OREQ      'M'
     C                   MOVEL     '03'          A_DDINST
     C                   ENDSL
      *
     C     DDCLTY        WHENEQ    '3'
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
     C                   MOVEL     '41'          A_DDINST
     C                   ENDIF
      *
     C     DDCLTY        WHENEQ    '4'
     C     DELF_CLAS     ANDEQ     'E'
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
     C                   MOVEL     '41'          A_DDINST
     C                   ENDIF
      *
     C                   ENDSL
      * Else Trade Sale.
     C                   ELSE
      *
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVEL     '02'          A_DDINST
     C                   MOVE      'MATCH'       A_DDINSS
      *
     C     DDCLTY        WHENEQ    '2'
     C                   SELECT
     C     DELT_CLAS     WHENEQ    'C'
     C                   MOVEL     '07C'         A_DDINST
     C                   MOVE      'MATCH'       A_DDINSS
     C*****DELT_CLAS     WHENEQ    'K'                                                        CSE022
     C**********         MOVEL     '07K'         A_DDINST                                     CSE022
     C     DELT_CLAS     WHENEQ    'X'
     C     DELT_CLAS     OREQ      'M'
     C                   MOVEL     '07'          A_DDINST
     C                   ENDSL
      *
     C     DDCLTY        WHENEQ    '3'
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
     C                   MOVEL     '51'          A_DDINST
     C                   ELSE
     C                   MOVEL     '31'          A_DDINST
     C                   ENDIF
      *
     C     DDCLTY        WHENEQ    '4'
     C     DELT_CLAS     ANDEQ     'E'
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
     C                   MOVEL     '51'          A_DDINST
     C                   ELSE
     C                   MOVEL     '31'          A_DDINST
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Euroclear/Cedel code
      ** --------------------
      *
     C                   MOVE      *BLANKS       W_EUCL
     C                   MOVE      *BLANKS       WW_EUCL           7
      *
      ** Customer classification = market
      *
     C     TCNR_CLAS     IFEQ      'M'
      *
      ***  Internal EOC.
      *
     C     DDCLTY        IFEQ      '1'
     C                   MOVEA(P)  TCNR_DRF1     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     W_EUCL           10
     C                   END
      *
      ***  Bridge EOC.
      *
     C     DDCLTY        IFEQ      '2'
     C                   MOVEA(P)  TCNR_DRF1     EUCL1
     C                   EXSR      EUCLF
     C*****'//XE'********CAT(P)****WW_EUCL:0*****W_EUCL****************                       214006
     C                   MOVE      *BLANKS       W_EUCL                                       214006
     C                   MOVEL     WW_EUCL       W_EUCL                                       214006
     C                   END
      *
      ***  Internal Cedel.
      *
     C     DDCLTY        IFEQ      '3'
     C                   MOVEA(P)  TCNR_DRF2     EUCL1                                         08971
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     W_EUCL
     C                   END
      *
      ***  Bridge Cedel.
      *
     C     DDCLTY        IFEQ      '4'
     C                   MOVEA(P)  TCNR_DRF2     EUCL1                                         08971
     C                   EXSR      EUCLF
     C*****'//XC'********CAT(P)****WW_EUCL:0*****W_EUCL****************                       214006
     C                   MOVE      *BLANKS       W_EUCL                                       214006
     C                   MOVEL     WW_EUCL       W_EUCL                                       214006
     C                   END
      *
      ***  More Bridge EOC.
      *
     C     DDCLTY        IFEQ      '2'
     C     DDTDTP        IFEQ      'TP'
     C     DELF_CLAS     ANDEQ     'C'
     C     DDTDTP        OREQ      'TS'
     C     DELT_CLAS     ANDEQ     'C'
     C                   MOVEA(P)  TCNR_DRF2     EUCL1
     C                   EXSR      EUCLF
     C*****'//XC'********CAT(P)****WW_EUCL:0*****W_EUCL****************                       214006
     C                   MOVE      *BLANKS       W_EUCL                                       214006
     C                   MOVEL     WW_EUCL       W_EUCL                                       214006
     C                   END
     C                   END
      *
     C     DDCLTY        IFEQ      '4'                                          more Bridge Cedel
     C     DDTDTP        IFEQ      'TP'
     C     DELF_CLAS     ANDEQ     'E'
     C     DDTDTP        OREQ      'TS'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVEA(P)  TCNR_DRF1     EUCL1
     C                   EXSR      EUCLF
     C*****'//XE'********CAT(P)****WW_EUCL:0*****W_EUCL****************                       214006
     C                   MOVE      *BLANKS       W_EUCL                                       214006
     C                   MOVEL     WW_EUCL       W_EUCL                                       214006
     C                   END
     C                   END
      *
      ** Customer classification NOT = market
      *
     C                   ELSE
 
     C     DELT          IFNE      DELF
      *
      ** Purchase
      *
     C     DDTDTP        IFEQ      'TP'
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVEA(P)  DELF_DRF1     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     W_EUCL
     C     DDCLTY        WHENEQ    '3'
     C                   MOVEA(P)  DELF_DRF2     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     W_EUCL
     C     DDCLTY        WHENEQ    '2'
     C     DELF_CLAS     ANDEQ     'C'
     C                   MOVEA(P)  DELF_DRF2     EUCL1
     C                   EXSR      EUCLF
     C*****'//XC'********CAT(P)****WW_EUCL:0*****W_EUCL****************                       214006
     C                   MOVE      *BLANKS       W_EUCL                                       214006
     C                   MOVEL     WW_EUCL       W_EUCL                                       214006
     C     DDCLTY        WHENEQ    '4'
     C     DELF_CLAS     ANDEQ     'E'
     C                   MOVEA(P)  DELF_DRF1     EUCL1
     C                   EXSR      EUCLF
     C*****'//XE'********CAT(P)****WW_EUCL:0*****W_EUCL****************                       214006
     C                   MOVE      *BLANKS       W_EUCL                                       214006
     C                   MOVEL     WW_EUCL       W_EUCL                                       214006
     C                   ENDSL
      *
      ** Else Sale
      *
     C                   ELSE
      *
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVEA(P)  DELT_DRF1     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     W_EUCL
     C     DDCLTY        WHENEQ    '3'
     C                   MOVEA(P)  DELT_DRF2     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     W_EUCL
     C     DDCLTY        WHENEQ    '2'
     C     DELT_CLAS     ANDEQ     'C'
     C                   MOVEA(P)  DELT_DRF2     EUCL1
     C                   EXSR      EUCLF
     C*****'//XC'********CAT(P)****WW_EUCL:0*****W_EUCL****************                       214006
     C                   MOVE      *BLANKS       W_EUCL                                       214006
     C                   MOVEL     WW_EUCL       W_EUCL                                       214006
     C     DDCLTY        WHENEQ    '4'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVEA(P)  DELT_DRF1     EUCL1
     C                   EXSR      EUCLF
     C*****'//XE'********CAT(P)****WW_EUCL:0*****W_EUCL****************                       214006
     C                   MOVE      *BLANKS       W_EUCL                                       214006
     C                   MOVEL     WW_EUCL       W_EUCL                                       214006
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     W_EUCL        A_DDEUCL
      *
      ** Safekeeping Account
      ** -------------------
      *
     C     CSE028        IFEQ      'N'                                                        CSE028
      *                                                                                       CSE028
     C     DDTDTP        IFEQ      'TP'
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C     DDCLTY        OREQ      '2'
     C                   MOVE      DELT_DRF1     A_DDSAFA
     C                   MOVEL     '/'           A_DDSAFA
     C     DDCLTY        WHENEQ    '3'
     C     DDCLTY        OREQ      '4'
     C                   MOVE      DELT_DRF2     A_DDSAFA
     C                   MOVEL     '/'           A_DDSAFA
     C                   ENDSL
      *
     C                   ELSE
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C     DDCLTY        OREQ      '2'
     C                   MOVE      DELF_DRF1     A_DDSAFA
     C                   MOVEL     '/'           A_DDSAFA
     C     DDCLTY        WHENEQ    '3'
     C     DDCLTY        OREQ      '4'
     C                   MOVE      DELF_DRF2     A_DDSAFA
     C                   MOVEL     '/'           A_DDSAFA
     C                   ENDSL
     C                   ENDIF
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *
      **  If Settlement Message Request is 'N' then set
      **  Counterparty/Cedel code & safekeeping Account to blanks
      **  -------------------------------------------------------
      *
     C     A_DDGMES      IFEQ      'N'
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C                   MOVE      *BLANKS       A_DDEUCL
     C                   MOVE      *BLANKS       A_DDSAFA
     C                   END
      *
      **  Requested priorty.
      ** ------------------
      *
     C     CSE028        IFEQ      'N'                                                        CSE028
      *                                                                                       CSE028
     C                   SELECT
     C     DDPRYC        WHENEQ    'W'
     C                   MOVE      '1'           A_DDRPTY
     C     DDPRYC        WHENEQ    'P'
     C                   MOVE      '2'           A_DDRPTY
     C     DDPRYC        WHENEQ    'R'
     C                   MOVE      '3'           A_DDRPTY
     C     DDPRYC        WHENEQ    'L'
     C                   MOVE      '4'           A_DDRPTY
     C                   ENDSL
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *
      **  Guaranteed Delivery.
      ** ------------------
      *
     C     DDPCOD        IFEQ      '5'
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C                   MOVE      'G'           A_DDGDEL
     C                   ENDIF
      *
      ** Network routing and addresses for confirmations
      ** -----------------------------------------------
      *
     C                   MOVE      TCNR          Sndr_DEPOT
     C                   MOVE      TCNR          Dest_DEPOT
      *
     C                   EXSR      SR1100
      *                                                                                       CSE028
     C     CSE028        IFEQ      'N'                                                        CSE028
     C     W_GME         OREQ      'N'                                                        223804
     C                   MOVE      'N'           A_DDGMEC
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C                   MOVE      W_ROU         A_DDROUC
     C                   MOVE      W_ROT         A_DDROTC
      *
      ** Customer/Counterparty Indicator
      ** -------------------------------
      *
     C     A_DDCCID      IFEQ      *BLANKS                                                  AR580916
     C     TCNR_CLAS     IFEQ      'M'
     C                   MOVE      'P'           A_DDCCID
     C                   ELSE
     C                   MOVE      'C'           A_DDCCID
     C                   ENDIF
     C                   ENDIF                                                              AR580916
      *
      ** Default fields retrieved from SESSIR0                                                CSE028
      *                                                                                       CSE028
     C     CSE028        IFEQ      'Y'                                                        CSE028
      *                                                                                       CSE028
     C***********        MOVE      SNEW          A_DDSNEW                              CSE028 225421
     C                   IF        A_DDSNEW = *BLANKs                                         225421
     C                   MOVE      'Y'           A_DDSNEW                                     225421
     C                   ENDIF                                                                225421
                                                                                              205208
     C***********        IF        SKAC <> *BLANKS                                     205208 212669
      ***********                                                                      205208 212669
     C***********        IF        DDTDTP = 'TP'                                       205208 212669
     C***********        MOVE      DELT          JFDEPO                                205208 212669
     C***********        ELSE                                                          205208 212669
     C***********        MOVE      DELF          JFDEPO                                205208 212669
     C***********        ENDIF                                                         205208 212669
      ***********                                                                      205208 212669
     C***********        CALL      'SEDORFRTV'                                         205208 212669
     C***********        PARM      *BLANKS       JFRETC           10                   205208 212669
     C***********        PARM                    JFDEPO            6                   205208 212669
     C***********        PARM                    SKAC                                  205208 212669
     C***********        PARM                    JFSKAL           20                   205208 212669
      ***********                                                                      205208 212669
     C***********        MOVEL     JFSKAL        A_DDSAFA                              205208 212669
     C***********        ENDIF                                                         205208 212669
                                                                                              205208
     C**********         MOVEL     SKAC          A_DDSAFA                              CSE028 205208
      *                                                                                       247327
      ** Reinstate and correct the defaulting of Safekeeping Account                          247327
      *                                                                                       247327
     C                   IF        SKAC <> *BLANKS                                            247327
     C                   MOVEL     SKAC          A_DDSAFA                                     247327
     C                   ELSE                                                                 247327
      *                                                                                       247327
     C                   IF        DDTDTP = 'TP'                                              247327
     C                   MOVE      DELT          JFDEPO                                       247327
     C                   ELSE                                                                 247327
     C                   MOVE      DELF          JFDEPO                                       247327
     C                   ENDIF                                                                247327
      *                                                                                       247327
     C                   IF        TCNR_CLAS = 'M'                                            247327
     C                   MOVEL     WWBICN        Holder                                       247327
     C                   ELSE                                                                 247327
     C                   MOVEL     TCNR          Holder                                       247327
     C                   ENDIF                                                                247327
      *                                                                                       247327
     C                   IF        CSE022 = 'Y'                                               247327
      *                                                                                       247327
     C                   CALL      'SEDORFRTV'                                                247327
     C                   PARM      *BLANKS       JFRETC           10                          247327
     C                   PARM                    JFDEPO            6                          247327
     C                   PARM                    Holder            6                          247327
     C                   PARM                    JFSKAL           20                          247327
      *                                                                                       247327
     C                   IF        JFSKAL = *BLANKS                                           247327
     C                   CALL      'SEDORFRTV'                                                247327
     C                   PARM      *BLANKS       JFRETC                                       247327
     C                   PARM                    JFDEPO                                       247327
     C                   PARM                    JFDEPO                                       247327
     C                   PARM                    JFSKAL                                       247327
     C                   ENDIF                                                                247327
      *                                                                                       247327
     C                   MOVEL     JFSKAL        A_DDSAFA                                     247327
      *                                                                                       247327
     C                   ENDIF                                                                247327
      *                                                                                       247327
     C                   ENDIF                                                                247327
      *                                                                                       247327
     C                   MOVE      SAINST        A_DDINST                                     CSE028
     C                   MOVE      SAINSS        A_DDINSS                                     CSE028
     C                   MOVE      SARPTY        A_DDRPTY                                     CSE028
     C                   MOVE      SAGDEL        A_DDGDEL                                     CSE028
     C                   MOVE      SASROL        A_DDSROL                                     CSE028
     C                   MOVE      SASTMP        A_DDSTMP                                     CSE028
     C                   MOVE      SACHID        A_DDCHID                                     CSE028
     C                   MOVE      SATRRM        A_DDTRRM                                     CSE028
      *                                                                                       201233
      ** Default settlement message to 'N' if destination is unroutable.                      201233
     C*****W_GME         IFNE      'N'                                                 201233 223804
     C     A_DDGMES      IFEQ      *BLANK                                                     223804
     C                   MOVE      SAGMES        A_DDGMES                                     CSE028
     C                   ENDIF                                                                201233
      *                                                                                       201233
     C     A_DDGMEC      IFEQ      *BLANK                                                     223804
     C                   MOVE      SACONG        A_DDGMEC                                     CSE028
     C                   ENDIF                                                                223804
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C     ENDSRINZA     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINZB - Routine to initialize screen fields with defaults.  *
      *                                                               *
      *****************************************************************
      *
     C     SRINZB        BEGSR
      **
      ** Network routing and addresses for settlements
      ** ---------------------------------------------
      **
     C     DDTDTP        IFEQ      'TP'
     C                   MOVE      DELF          Sndr_DEPOT
     C                   MOVE      DELF          Dest_DEPOT
     C                   ELSE
     C                   MOVE      DELT          Sndr_DEPOT
     C                   MOVE      DELT          Dest_DEPOT
     C                   ENDIF
      *
     C                   EXSR      SR1100
      *                                                                                       CSE028
     C     CSE028        IFEQ      'N'                                                        CSE028
     C                   MOVE      W_GME         B_DDGMES
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C                   MOVE      W_ROU         B_DDROUS
     C                   MOVE      W_ROT         B_DDROTS
      *
      ** Default Settlement request to N if backvaluation
      ** ------------------------------------------------
      *
     C     DDACTN        IFEQ      'I'
     C     TDVD          ANDLT     BJRDNB
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C                   MOVE      'N'           B_DDGMES
     C                   END
      *
      ** Settlement Message
      ** ------------------
      *
     C     CSW003        IFEQ      'Y'
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C     TCNR_CLAS     IFEQ      'S'
     C     DELT          ANDEQ     DELF
     C     TCNR_CLAS     OREQ      'D'
     C     DELT          ANDEQ     DELF
     C                   MOVE      'N'           B_DDGMES
     C                   ENDIF
     C                   ENDIF
      *                                                                                      201233
      ** Default settlement message to 'N' if destination is unroutable.                     201233
      *                                                                                      201233
     C     W_GME         IFEQ      'N'                                                       201233
     C                   MOVE      'N'           B_DDGMES                                    201233
     C                   ENDIF                                                               201233
      *
      ** Time of trade
      ** -------------
      *
     C                   MOVE      A_DDTRTT      B_DDTRTT
      *
      ** Instructions type and sub-type
      ** ------------------------------
      *
     C     CSE028        IFEQ      'N'                                                        CSE028
      *                                                                                       CSE028
     C     DDTDTP        IFEQ      'TP'
      *
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVEL     '02'          B_DDINST
     C                   MOVE      'MATCH'       B_DDINSS
      *
     C     DDCLTY        WHENEQ    '2'
     C     DELF_CLAS     ANDEQ     'C'
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
     C                   MOVEL     '51'          B_DDINST
     C                   ELSE
     C                   MOVEL     '31'          B_DDINST
     C                   ENDIF
      *
     C     DDCLTY        WHENEQ    '3'
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
     C                   MOVEL     '51'          B_DDINST
     C                   ELSE
     C                   MOVEL     '31'          B_DDINST
     C                   ENDIF
     C     DDCLTY        WHENEQ    '4'
     C     DELF_CLAS     ANDEQ     'E'
     C                   MOVEL     '07C'         B_DDINST
     C                   MOVEL     'MATCH'       B_DDINSS
      *
     C     DDCLTY        WHENEQ    '5'
     C     DELF_CLAS     ANDEQ     'E'
     C                   MOVEL     '07 '         B_DDINST
     C                   ENDSL
      * Else TS
     C                   ELSE
      *
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVEL     '01'          B_DDINST
     C                   MOVE      'MATCH'       B_DDINSS
      *
     C     DDCLTY        WHENEQ    '2'
     C     DELT_CLAS     ANDEQ     'C'
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
     C                   MOVEL     '41'          B_DDINST
     C                   ENDIF
      *
     C     DDCLTY        WHENEQ    '3'
     C     DDPCOD        IFEQ      '1'
     C     DDPCOD        OREQ      '5'
     C                   MOVEL     '41'          B_DDINST
     C                   ENDIF
      *
     C     DDCLTY        WHENEQ    '4'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVEL     '03C'         B_DDINST
     C                   MOVE      'MATCH'       B_DDINSS
      *
     C     DDCLTY        WHENEQ    '5'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVEL     '03 '         B_DDINST
     C                   ENDSL
      *
     C                   ENDIF
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *
      ** Euroclear/Cedel code
      ** --------------------
      *
     C     DDTDTP        IFEQ      'TP'
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVEA(P)  DELT_DRF1     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     B_DDEUCL
     C     DDCLTY        WHENEQ    '3'
     C                   MOVEA(P)  DELT_DRF2     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     B_DDEUCL
     C     DDCLTY        WHENEQ    '2'
     C     DELF_CLAS     ANDEQ     'C'
     C                   MOVEA(P)  DELT_DRF1     EUCL1
     C                   EXSR      EUCLF
     C*****'//XE'********CAT(P)****WW_EUCL:0*****B_DDEUCL**************                       214006
     C                   MOVE      *BLANKS       B_DDEUCL                                     214006
     C                   MOVEL     WW_EUCL       B_DDEUCL                                     214006
     C     DDCLTY        WHENEQ    '4'
     C     DELF_CLAS     ANDEQ     'E'
     C                   MOVEA(P)  DELT_DRF2     EUCL1
     C                   EXSR      EUCLF
     C*****'//XC'********CAT(P)****WW_EUCL:0*****B_DDEUCL**************                       214006
     C                   MOVE      *BLANKS       B_DDEUCL                                     214006
     C                   MOVEL     WW_EUCL       B_DDEUCL                                     214006
     C                   ENDSL
      *   ELSE  (NOT TP)
     C                   ELSE
      *
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVEA(P)  DELF_DRF1     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     B_DDEUCL
     C     DDCLTY        WHENEQ    '3'
     C                   MOVEA(P)  DELF_DRF2     EUCL1
     C                   EXSR      EUCLF
     C     '/'           CAT(P)    WW_EUCL:0     B_DDEUCL
     C     DDCLTY        WHENEQ    '2'
     C     DELT_CLAS     ANDEQ     'C'
     C                   MOVEA(P)  DELF_DRF1     EUCL1
     C                   EXSR      EUCLF
     C*****'//XE'********CAT(P)****WW_EUCL:0*****B_DDEUCL**************                       214006
     C                   MOVE      *BLANKS       B_DDEUCL                                     214006
     C                   MOVEL     WW_EUCL       B_DDEUCL                                     214006
     C     DDCLTY        WHENEQ    '4'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVEA(P)  DELF_DRF2     EUCL1
     C                   EXSR      EUCLF
     C*****'//XC'********CAT(P)****WW_EUCL:0*****B_DDEUCL**************                       214006
     C                   MOVE      *BLANKS       B_DDEUCL                                     214006
     C                   MOVEL     WW_EUCL       B_DDEUCL                                     214006
     C                   ENDSL
      *
     C                   ENDIF
      *
      ** Safekeeping Account
      ** -------------------
      *
     C     CSE028        IFEQ      'N'                                                        CSE028
      *                                                                                       CSE028
     C     DDTDTP        IFEQ      'TP'
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVE      DELF_DRF1     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '3'
     C                   MOVE      DELF_DRF2     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '4'
     C     DELF_CLAS     ANDEQ     'E'
     C                   MOVE      DELF_DRF1     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '2'
     C     DELF_CLAS     ANDEQ     'C'
     C                   MOVE      DELF_DRF2     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '5'
     C     DELF_CLAS     ANDEQ     'E'
     C                   MOVE      DELF_DRF1     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '5'
     C     DELF_CLAS     ANDEQ     'C'
     C                   MOVE      DELF_DRF2     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C                   ENDSL
      *
     C                   ELSE
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C                   MOVE      DELT_DRF1     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '3'
     C                   MOVE      DELT_DRF2     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '4'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVE      DELT_DRF1     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '2'
     C     DELT_CLAS     ANDEQ     'C'
     C                   MOVE      DELT_DRF2     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '5'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVE      DELT_DRF1     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C     DDCLTY        WHENEQ    '5'
     C     DELT_CLAS     ANDEQ     'C'
     C                   MOVE      DELT_DRF2     B_DDSAFA
     C                   MOVEL     '/'           B_DDSAFA
     C                   ENDSL
     C                   ENDIF
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *
      **  If Settlement Message Request is 'N' then set
      **  Counterparty/Cedel code & safekeeping Account to blanks
      **  -------------------------------------------------------
      *
     C     B_DDGMES      IFEQ      'N'
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C                   MOVE      *BLANKS       B_DDEUCL
     C                   MOVE      *BLANKS       B_DDSAFA
     C                   ENDIF
      *
      * Move fields from A screen to B, if fields are not non-display
      *
     C     NonDspF_A     IFEQ      'N'
     C     NonDspF_B     ANDEQ     'N'
     C                   MOVE      A_DDFTID      B_DDFTID
     C                   MOVE      A_DDFCOD      B_DDFCOD
     C                   ENDIF
      *
     C     NonDspI_A     IFEQ      'N'
     C     NonDspI_B     ANDEQ     'N'
     C     CSE028        ANDEQ     'N'                                                        CSE028
     C                   MOVE      A_DDRPTY      B_DDRPTY
     C                   MOVE      A_DDGDEL      B_DDGDEL
     C                   MOVE      A_DDSROL      B_DDSROL
     C                   ENDIF
      *
      ** Network routing for confirmations
      ** ---------------------------------
      *
     C     CSE028        IFEQ      'N'                                                        CSE028
     C                   MOVE      'N'           B_DDGMEC
     C                   ENDIF                                                                CSE028
      *
      ** Default fields from SESSIR0                                                          CSE028
      *                                                                                       CSE028
     C     CSE028        IFEQ      'Y'                                                        CSE028
      *                                                                                       CSE028
     C                   MOVEL     SKAC          B_DDSAFA                                     CSE028
     C***********        MOVE      SNEW          B_DDSNEW                              CSE028 225421
     C                   IF        B_DDSNEW = *BLANKS                                         225421
     C                   MOVE      'Y'           B_DDSNEW                                     225421
     C                   ENDIF                                                                225421
     C                   MOVE      SAINST        B_DDINST                                     CSE028
     C                   MOVE      SAINSS        B_DDINSS                                     CSE028
     C                   MOVE      SARPTY        B_DDRPTY                                     CSE028
     C                   MOVE      SAGDEL        B_DDGDEL                                     CSE028
     C                   MOVE      SASROL        B_DDSROL                                     CSE028
     C                   MOVE      SASTMP        B_DDSTMP                                     CSE028
     C                   MOVE      SACHID        B_DDCHID                                     CSE028
     C                   MOVE      SATRRM        B_DDTRRM                                     CSE028
      *                                                                                       201233
      ** Default settlement message to 'N' if destination is unroutable.                      201233
     C*****W_GME         IFNE      'N'                                                 201233 263512
     C     B_DDGMES      IFEQ      *BLANK                                                     263512
     C                   MOVE      SAGMES        B_DDGMES                                     CSE028
     C                   ENDIF                                                                201233
      *                                                                                       201233
     C     A_DDGMEC      IFNE      'N'                                                        223804
     C                   MOVE      SACONG        B_DDGMEC                                     CSE028
     C                   ENDIF                                                                223804
      *                                                                                       CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  EUCLF  - Remove leading blanks from Euroclear/Cedel Code     *
      *****************************************************************
     C     EUCLF         BEGSR
      *
      ** If the array is empty, do not try to remove leading blanks
      ** Otherwise, following existing logic.
      *
     C                   MOVEA     EUCL1         W0EUCL            6
     C     W0EUCL        IFEQ      *BLANK
     C                   MOVEL     *BLANK        WW_EUCL
     C                   ELSE
     C                   Z-ADD     1             I                 3 0
     C     I             DOWLE     6
     C     EUCL1(I)      ANDEQ     *BLANK
     C                   ADD       1             I
     C                   ENDDO
     C                   MOVEA(P)  EUCL1(I)      EUCL2
     C                   MOVEA(P)  EUCL2         WW_EUCL
     C                   END
      *
     C     EndEUCLF      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SR1100 - Determine Network and Addresses.                    *
      *****************************************************************
     C     SR1100        BEGSR
      *
     C                   CALL      'ZM1100'                             99
     C                   PARM                    Sndr_DEPOT
     C                   PARM      *BLANKS       @SCSD            12
     C                   PARM                    Dest_DEPOT
     C                   PARM                    DDSETP
     C                   PARM      *BLANKS       @NWSN            20
     C                   PARM      *BLANKS       @NWDS            22
     C                   PARM      *BLANKS       @NWRK             6
     C                   PARM      *BLANKS       @ERRC             1
     C                   PARM      *BLANKS       @SRNM            20
     C                   PARM      *BLANKS       @SRTN            10
     C                   PARM      *BLANKS       @DRNM            20
     C                   PARM      *BLANKS       @DRTN            10
      *
     C     Sndr_DEPOT    IFNE      *BLANKS
     C     Dest_DEPOT    ANDNE     *BLANKS
      *
     C     *IN99         IFEQ      '1'
     C     @ERRC         OREQ      'S'
     C     @ERRC         OREQ      'D'
     C     @NWRK         OREQ      'UNROUT'
     C                   MOVE      'N'           W_GME             1
     C                   MOVEL     *BLANKS       W_ROU             6
     C                   MOVEL     '  UNRO'      W_ROT            12
     C                   MOVE      'UTABLE'      W_ROT
     C                   ELSE
      *
     C                   MOVE      'Y'           W_GME
     C                   MOVEL     @NWRK         W_ROU
     C                   MOVEA     @NWDS         ROU
     C                   Z-ADD     1             J                 2 0
     C     ' '           LOOKUP    ROU(J)                                 85
     C     *IN85         IFEQ      '0'                                          not found.
     C                   MOVEL     @NWDS         W_ROT
     C                   ELSE                                                   found.
     C     14            SUB       J             K                 2 0
     C                   MOVEA     *ALL' '       ROU
     C                   MOVEA     @NWDS         ROU(K)
     C                   MOVEA     ROU           W_ROT
     C                   END
     C                   END
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIAL PROCESSING (NON *INZSR)
      *****************************************************************
     C     INIT          BEGSR
                                                                                              CSE028
      ** Initialize work fields                                                               CSE028
                                                                                              CSE028
     C                   EVAL      DELF_CLAS = *Blanks                                        CSE028
     C                   EVAL      DELF_DRF1 = *Blanks                                        CSE028
     C                   EVAL      DELF_DRF2 = *Blanks                                        CSE028
     C                   EVAL      DELT_CLAS = *Blanks                                        CSE028
     C                   EVAL      DELT_DRF1 = *Blanks                                        CSE028
     C                   EVAL      DELT_DRF2 = *Blanks                                        CSE028
      *
      * Retrieve Securities Trading info for Deliver From Depot (DELF)
      * --------------------------------------------------------------
      *
     C*****DELF          IFNE      *ZEROS                                                    CSD027B
     C     DELF          IFNE      '      '                                                  CSD027B
     C                   MOVE      DELF          @SCKY             6
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   MOVE      BFCLAS        DELF_CLAS         1
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF1        DELF_DRF1         6
     C                   MOVE      BFDRF2        DELF_DRF2         6
     C                   ENDIF
      *
      * Retrieve Securities Trading info for 'Deliver To' Depot (DELT)
      * --------------------------------------------------------------
      *
     C*****DELT          IFNE      *ZEROS                                                    CSD027B
     C     DELT          IFNE      '      '                                                  CSD027B
     C                   MOVE      DELT          @SCKY
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   MOVE      BFCLAS        DELT_CLAS         1
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF1        DELT_DRF1         6
     C                   MOVE      BFDRF2        DELT_DRF2         6
     C                   ENDIF
      *
      * Retrieve Securities Trading info for Counterparty (TCNR)
      * --------------------------------------------------------
      *
     C*****TCNR          IFNE      *ZEROS                                             208195 CSD027B
     C     TCNR          IFNE      '      '                                                  CSD027B
     C                   MOVE      TCNR          @SCKY
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @SCKY
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   MOVE      BFCLAS        TCNR_CLAS         1
     C                   MOVEL     BFNDR1        BFDRF1                                       CSE022
     C                   MOVEL     BFNDR2        BFDRF2                                       CSE022
     C                   MOVE      BFDRF1        TCNR_DRF1         6                           S0111
     C                   MOVE      BFDRF2        TCNR_DRF2         6                           S0111
     C                   ENDIF                                                                208195
      *                                                                                       247327
      ** Check Branch Internal Customer                                                       247327
      *                                                                                       247327
     C                   MOVEL     DDBRCD        WDSNB             3                          247327
     C                   CALL      'AOBRCHR1'                                                 247327
     C                   PARM      '*DBERR '     @RTCD                                        247327
     C                   PARM      '*KEY   '     @OPTN                                        247327
     C                   PARM                    WDSNB                                        247327
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        247327
      *                                                                                       247327
     C                   MOVE      A8BICN        WWBICN            6 0                        247327
      *
      ** If SWIFT MT500 phase 2 installed
      *
     C                   MOVE      'N'           NonDspF_A         1
     C                   MOVE      'N'           NonDspI_A         1
      *
     C                   MOVE      'N'           NonDspF_B         1
     C                   MOVE      'N'           NonDspI_B         1
      *
     C     CSW003        IFEQ      'Y'
      *
      ** Determine fields to display on screen A.
      *
     C                   SELECT
     C     DDCLTY        WHENEQ    '1'
     C     DDCLTY        OREQ      '2'
     C                   MOVE      'Y'           NonDspF_A
     C     DDCLTY        WHENEQ    '5'
     C                   MOVE      'Y'           NonDspF_A
     C                   MOVE      'Y'           NonDspI_A
     C                   ENDSL
      *
      ** Check whether screen B is required
      *
     C     TCNR_CLAS     IFEQ      'S'
     C     DELT          ANDNE     DELF
     C     TCNR_CLAS     OREQ      'D'
     C     DELT          ANDNE     DELF
      *
      ** Determine fields to display on screen B.
      *
     C     DDCLTY        IFEQ      '1'
     C                   MOVE      'Y'           NonDspF_B
     C                   ENDIF
      *
     C     DDCLTY        IFNE      '1'
     C     DDCLTY        ANDNE     '3'
     C     DDTDTP        IFEQ      'TP'
     C     DELF_CLAS     ANDEQ     'E'
     C     DDTDTP        OREQ      'TS'
     C     DELT_CLAS     ANDEQ     'E'
     C                   MOVE      'Y'           NonDspF_B
     C                   ENDIF
     C     DDTDTP        IFEQ      'TP'
     C     DELF_CLAS     ANDNE     'E'
     C     DELF_CLAS     ANDNE     'C'
     C     DDTDTP        OREQ      'TS'
     C     DELT_CLAS     ANDNE     'E'
     C     DELT_CLAS     ANDNE     'C'
     C                   MOVE      'Y'           NonDspF_B
     C                   MOVE      'Y'           NonDspI_B
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS :
      *
      * Screen (A or B)
     C                   PARM                    Screen            1
      *
      * Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETP            2
     C                   PARM                    DDCLTY            1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD            3                          CSE028
     C                   PARM                    DDBPBK            2                          CSE028
     C                   PARM                    DDSETC            3                          CSE028
     C                   PARM                    DDMRKT            2                          CSE034
      *
      * Trade Details (file)
     C                   PARM                    TDVD
     C                   PARM                    TCNR
     C                   PARM                    DELF
     C                   PARM                    DELT
     C                   PARM                    InvType                                      199797
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      ** OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    A_TrSwft
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    B_TrSwft
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 902*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      * Retrieve Securities Trading ICD info
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                       CSE028
      ** Check if CSE028 feature is installed                                                 CSE028
      *                                                                                       CSE028
     C                   CALLB     'AOSARDR0'                                                 CSE028
     C                   PARM      *BLANKS       @RTCD                                        CSE028
     C                   PARM      '*VERIFY'     @OPTN                                        CSE028
     C                   PARM      'CSE028'      @SARD             6                          CSE028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE028
      *                                                                                       CSE028
      ** Database Error                                                                       CSE028
      *                                                                                       CSE028
     C     @RTCD         IFNE      *BLANKS                                                    CSE028
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE028
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE028
     C                   MOVEL     '902'         DBASE                                        CSE028
     C                   MOVEL     @SARD         DBKEY                                        CSE028
     C                   EXSR      *PSSR                                                      CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       CSE028
     C     @RTCD         IFEQ      *BLANK                                                     CSE028
     C                   MOVE      'Y'           CSE028            1                          CSE028
     C                   ELSE                                                                 CSE028
     C                   MOVE      'N'           CSE028                                       CSE028
     C                   ENDIF                                                                CSE028
      *                                                                                       247327
      ** Check if CSE022 feature is installed                                                 247327
      *                                                                                       247327
     C                   CALLB     'AOSARDR0'                                                 247327
     C                   PARM      *BLANKS       @RTCD                                        247327
     C                   PARM      '*VERIFY'     @OPTN                                        247327
     C                   PARM      'CSE022'      @SARD                                        247327
     C     SCSARD        PARM      SCSARD        DSFDY                                        247327
      *                                                                                       247327
     C     @RTCD         IFNE      *BLANKS                                                    247327
     C     @RTCD         ANDNE     '*NRF   '                                                  247327
     C                   MOVEL     'SCSARDPD'    DBFILE                                       247327
     C                   MOVEL     '903'         DBASE                                        247327
     C                   MOVEL     @SARD         DBKEY                                        247327
     C                   EXSR      *PSSR                                                      247327
     C                   ENDIF                                                                247327
      *                                                                                       247327
     C     @RTCD         IFEQ      *BLANK                                                     247327
     C                   MOVE      'Y'           CSE022            1                          247327
     C                   ELSE                                                                 247327
     C                   MOVE      'N'           CSE022                                       247327
     C                   ENDIF                                                                247327
      *
     C                   ENDSR
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
