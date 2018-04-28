     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Federal States Codes')               *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVGERCOD - Validate State Codes                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *    This source is created as a validation for the third       *
      *    tax details.                                               *
      *                                                               *
      *  Last Amend No. AR739532           Date 30Mar11               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG25854           Date 08Sep09               *
      *                 BUG25533           Date 19Aug09               *
      *                 CER054  *CREATE    Date 07Apr09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR739532 - CUSD Error issued if State code has value         *
      *             (Child : AR739533)                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25854 - ACUD difficulties with State Code and Religion    *
      *  BUG25533 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *             (Applied BUG24714 fix)                            *
      *  BUG24714 - Non Generation of Withholding Tax per Federal     *
      *             State Report during Input Cycle and after COB     *
      *  CER054 - German Features - Church Tax                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Country Details
     D*SDCUST***     E DS                  EXTNAME(SDCUSTPD)                                AR739532
 
      ** External DS for Federal State Code Details
     D SDSTCD        E DS                  EXTNAME(SDGESTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D*DDCUST***       S              6A                                                    AR739532
     D DDCOLC          S              2A                                                    AR739532
     D DDSTCD          S              2A
     D DDRLAF          S              4A
     D OKSTCD          S              1A
     D @RUN            S              1A
     D CER048          S              1A                                                    BUG24714
     D CER054          S              1A                                                    BUG24714
 
      ** Parameter for Access Object
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
 
     D WRtCd           S              7A
     D WOptn           S              7A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initial Processing
 
     C                   EXSR      SRInit
 
      ** Validate Federal State Code
 
     C                   IF        CER048 = 'Y'                                             BUG24714
     C                   EXSR      SRValFedCod
     C                   ENDIF                                                              BUG24714
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        OKSTCD = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValFedCod - Validate Federal State Code                     *
      *                                                               *
      *****************************************************************
 
     C     SRValFedCod   BEGSR
 
      ** Check customer details
 
     C**********         MOVEL     DDCUST        PKEY1                                      AR739532
 
     C**********         CALLB     'AOCUSTR0'                                               AR739532
     C**********         PARM      *Blanks       PRTCD                                      AR739532
     C**********         PARM      '*KEY   '     POPTN                                      AR739532
     C**********         PARM                    PKEY1                                      AR739532
     C**********         PARM                    PKYST                                      AR739532
     C*****SDCUST        PARM      SDCUST        DSSDY                                      AR739532
 
     C                   IF        DDSTCD <> *BLANKS
      *
      ***The*State*codes*can*be*input*for*customers*with*country*of*tax*equal*              AR739532
      ****to*country*of*location**********************************************              AR739532
      *
     C**********         IF        BBCOLC <> BJCNCD                                         AR739532
      *                                                                                     AR739532
      ** The State code entry will be validated with Country of Domicile input              AR739532
      **  against the country of location defined in SDBANKPD                               AR739532
      *                                                                                     AR739532
     C                   IF        DDCOLC <> BJCNCD                                         AR739532
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTCD'      FldNamXAr(Idx)
     C                   MOVEL     'USR8321'     MsgIDXAr(Idx)
     C                   EVAL      OKSTCD = 'N'
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   IF        CER054 = 'Y'                                             BUG24714
      *
      ***The*State*code*can*be*input*if*Religious*Affiliation******                         BUG25854
      ***Code*is*not*equal*to*'NONE'*******************************                         BUG25854
      *                                                                                     BUG25854
     C**********         IF        DDRLAF = 'NONE'                                          BUG25854
     C**********         ADD       1             Idx                                        BUG25854
     C**********         MOVEL     'DDSTCD'      FldNamXAr(Idx)                             BUG25854
     C**********         MOVEL     'USR9909'     MsgIDXAr(Idx)                              BUG25854
     C**********         EVAL      OKSTCD = 'N'                                             BUG25854
     C**********         GOTO      ENDVAL                                                   BUG25854
     C**********         ENDIF                                                              BUG25854
     C                   ENDIF                                                              BUG24714
     C
      *
      ** Check if the State Code input exist in the Federal State
      ** Code table.
      *
     C                   EVAL      PKEY1 = DDSTCD
 
     C                   CALL      'AOSTCDR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C     SDSTCD        PARM      SDSTCD        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDSTCD'      FldNamXAr(Idx)
     C                   MOVEL     'USR8322'     MsgIDXAr(Idx)
     C                   EVAL      OKSTCD = 'N'
     C                   GOTO      ENDVAL
     C                   ELSE
     C                   EVAL      DDSTCD = GESTCD
     C                   ENDIF
 
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ***Customer*Number***********************************************                     AR739532
     C**********         PARM                    DDCUST                                     AR739532
                                                                                            AR739532
      ** Country of Domicile                                                                AR739532
     C                   PARM                    DDCOLC                                     AR739532
 
      ** State Code
     C                   PARM                    DDSTCD
 
      ** Religious Affiliation Code
     C                   PARM                    DDRLAF
 
      ** Switchable Feature                                                                 BUG24714
     C                   PARM                    CER048                                     BUG24714
     C                   PARM                    CER054                                     BUG24714
                                                                                            BUG24714
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** State Code - OK
     C                   PARM                    OKSTCD
 
      *
      ** Retrieving the bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRtCd
     C                   PARM      '*FIRST '     WOptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        WRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     001           DBase
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBPgm = 'SD200204'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *Blanks
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2009
