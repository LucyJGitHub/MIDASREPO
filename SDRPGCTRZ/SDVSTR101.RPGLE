     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Street of Residence 1')              *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVSTR101 - Validate Street of Residence 1                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR808915           Date 29Jul11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256481B            Date 24Nov08               *
      *                 256564             Date 17Sep08               *
      *                 250804A            Date 11Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10069           Date 25Jan06               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR808915 - Old value are kept in the additional customer     *
      *             detail (Child:AR808916)                           *
      *  256481B - Do not default value for Additional Customer Name  *
      *            and Address if system value is not required        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250804A - Correct defaulting of additional customer details  *
      *           from main customer details.                         *
      *  BUG10069 - If no customer details exist, check the shadow    *
      *             file.                                             *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
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
 
      ** Midas SD Customer Details Retrieval Shadow File                                    BUG10069
     FSDCDSHL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG10069
     F                                     RENAME(@BBREBF:SDCDSHD1)                         BUG10069
 
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                             256481B
      **  Access the System Value                                                            256481B
     D SVAL01          C                   CONST('AdditionalNameAddres')                     256481B
                                                                                             256481B
      **  Data Structure for AOSVALR0 string                                                 256481B
     DSVAL1            DS           200                                                      256481B
     DSVAL11                   1      1                                                      256481B
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @RUN            S              1A
     D DDCUST          S              6A
     D DDCNA3          S             35A
     D DDOKCNA3        S              1A
     D PTaxStat        S              1A                                                      232543
     D PJACType        S              1A                                                      232543
 
      ** Parameter for Access Object
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKEY1           S             10A
     D PKYST           S              7A
 
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
 
      ** Validation
 
     C                   EXSR      SRVCNA3
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOKCNA3 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCNA3 - Validate Street of Residence 1                      *
      *                                                               *
      *****************************************************************
 
     C     SRVCNA3       BEGSR
 
      ** Set up Street of Residence 1, default to BBCNA2 when blank
 
     C                   IF        DDCNA3 = *Blanks
     C                   IF        SVAL11='Y'                                                256481B
     C**********         EVAL      DDCNA3 = BBCNA2                                           250804A
     C                   EVAL      DDCNA3 = BBCNA3                                           250804A
     C                   ENDIF                                                               256481B
     C                   ENDIF
 
      ** If Street of Residence 1 still blank, this is a mandatory entry
      ** If Status is 'D'isclosed                                                             232543
      ** and Joint A/c Type is 'I' or 'Y' (not 'N')                                           232543
 
     C                   IF        DDCNA3 = *Blanks
     C                             And PTaxStat = 'D'                                         232543
     C                             And PJACType <> 'N'                                        232543
     C                   EVAL      DDOKCNA3 = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCNA3'      FldNamXAr(Idx)
als  C                   MOVEL     'USR4777'     MsgIDXAr(Idx)
     C                   GOTO      ENDVAL
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
 
      ** Check customer details
 
     C                   MOVEL     DDCUST        PKEY1
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD = '*NRF   '
     C     DDCUST        CHAIN     SDCDSHL1                                                 BUG10069
     C                   IF        NOT %FOUND                                               BUG10069
     C**********         EVAL      BBCNA2 = *Blanks                                         AR808915
     C                   EVAL      BBCNA3 = *BLANKS                                         AR808915
     C                   ENDIF                                                              BUG10069
     C                   ENDIF
 
      *                                                                                      256481B
      ** Call AOSVALR0 to get the system value for the                                       256481B
      ** Defaulting of Additional Name and Address                                           256481B
      *                                                                                      256481B
     C                   CALL      'AOSVALR0'                                                256481B
     C                   PARM                    @RTCD                                       256481B
     C                   PARM      SVAL01        SVALK1           20                         256481B
     C                   PARM                    SVAL1           200                         256481B
     C                   PARM                    SVALK2           20                         256481B
     C                   PARM                    SVAL2           200                         256481B
     C                   PARM                    SVALK3           20                         256481B
     C                   PARM                    SVAL3           200                         256481B
     C                   PARM                    SVALK4           20                         256481B
     C                   PARM                    SVAL4           200                         256481B
     C                   PARM                    SVALK5           20                         256481B
     C                   PARM                    SVAL5           200                         256481B
     C                   PARM                    SVALK6           20                         256481B
     C                   PARM                    SVAL6           200                         256481B
     C                   PARM                    SVALK7           20                         256481B
     C                   PARM                    SVAL7           200                         256481B
     C                   PARM                    SVALK8           20                         256481B
     C                   PARM                    SVAL8           200                         256481B
     C                   PARM                    SVALK9           20                         256481B
     C                   PARM                    SVAL9           200                         256481B
     C                   PARM                    SVALK10          20                         256481B
     C                   PARM                    SVAL10          200                         256481B
      *                                                                                      256481B
      ** If the system value is not found then issue a database error                        256481B
     C                   IF        @RTCD <> '*NRF' AND                                       256481B
     C                             @RTCD <> *BLANKS                                          256481B
      *                                                                                      256481B
     C     *LOCK         IN        LDA                                                       256481B
     C                   EVAL      DBFile = 'SDSVALPD'                                       256481B
     C                   EVAL      DBase = 990                                               256481B
     C                   EVAL      DBKey = SVALK1                                            256481B
      *                                                                                      256481B
     C                   OUT       LDA                                                       256481B
     C                   EXSR      *PSSR                                                     256481B
     C                   ENDIF                                                               256481B
                                                                                             256481B
      ** Initialization
 
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
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
 
      ** Customer Number
     C                   PARM                    DDCUST
 
      ** Street of Residence
     C                   PARM                    DDCNA3
 
      ** Tax Status                                                                           232543
     C                   PARM                    PTaxStat                                     232543
                                                                                              232543
      ** Joint A/c Type                                                                       232543
     C                   PARM                    PJACType                                     232543
                                                                                              232543
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
     C                   PARM                    DDOKCNA3
 
 
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
(c) Finastra International Limited 2004
