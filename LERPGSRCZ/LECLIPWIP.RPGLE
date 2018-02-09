     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Cust loans addtl WIP screen fmt convert')     *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending                                     *
      *                                                               *
      *  LECLIPWIP -  Customer loans additional WIP Screen Format     *
      *               Conversion                                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD025521           Date 19Aug14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106  *CREATE    Date 01Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  245273 - Recompiled due to changes in LECLI1PD.              *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LECLI1PD)
     D TranInSeco    E DS                  EXTNAME(LECLI2PD)
     D TranInThir    E DS                  EXTNAME(LECLI3PD)
 
      * Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      * Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters
     D PRtcd           S              7
     D POptn           S              7
     D PCurr           S              3
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
      ** Working Variables
     D WXRate          S             14  8
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Convert fields from WIP (Work in Progress) to match formatting
      ** done on fields that are retrieved from file.
      ** i.e. a numeric field from file is *zero not *blank.
 
     C                   EXSR      SrConSeco
     C                   EXSR      SrConThir
 
     C                   EXSR      SrExit
 
     C                   RETURN
 
      *****************************************************************
      ** SrConSeco - Convert fields of Transaction Second Details
      *****************************************************************
     C     SrConSeco     BEGSR
 
      ** IPRD Interest Paid/Recvd to Date
 
     C                   MOVE      *Blanks       ZFLD15
     C                   MOVE      DDIPRD        ZFLD15
 
     C                   IF        DDIPRD = *Blanks Or ZFLD15 = *Zero
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCURR        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      A6NBDP        ZDECS
     C                   PARM      *Blanks       ZECODE
     C                   PARM                    ZOUT21
     C                   MOVE      ZOUT21        DDIPRD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrConThir - Convert fields of Transaction Third Details
      *****************************************************************
     C     SrConThir     BEGSR
 
      ** BCXR Base Currency Exchange Rate
 
     C                   MOVE      DDBCXR        WXRate
     C                   IF        DDBCXR = *Blanks Or WXRate = *Zeros
     C                   EVAL      DDBCXR = '0'
     C                   ENDIF
 
      ** FCXR Facility Currency Exchange Rate
 
     C                   MOVE      DDFCXR        WXRate
     C                   IF        DDFCXR = *Blanks Or WXRate = *Zeros
     C                   EVAL      DDFCXR = '0'
     C                   ENDIF
 
      ** Billing / Telex Indicator
 
     C                   IF        DDBTIN = *Blanks
     C                   EVAL      DDBTIN = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS and OUTPUTS
      ** Loan Details requiring format changes
 
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInThir
 
      **  Move program name into *LDA field.
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'LECLIPWIP'   DBPGM
     C                   OUT       LDA
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Set up the name of the MSGF from which the message handler will
      *  get the messages
 
     C                   EVAL      #MsgFile = 'LERMSGF'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrExit - Termination processing.
      *****************************************************************
     C     SrExit        BEGSR
 
      **  Terminate program
 
     C                   EVAL      *INLR = *ON
 
     C                   IF        *INU7 = *ON
     C                   DUMP
     C                   END
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2005
