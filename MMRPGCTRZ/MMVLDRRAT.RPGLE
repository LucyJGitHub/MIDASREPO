     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM LDNI Validate Reference Rate')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  MMVLDRRAT  - Validate MM LDNI Reference Rate                 *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Reference Rate and confirms if valid.             *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 MD023981           Date 13Jan14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049  *CREATE    Date 08May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  MD023981 - Incorrect validation of rates when the decimal    *
      *             separator in the Dealing ICD was defined as ","   *
      *             instead of ".".                                   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CDL049 - Addition of a Reference Rate field                  *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
 
      * SD Reference Rate Tolerance File
     FSDRRATPD  IF   E             DISK    INFSR(*PSSR)
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(MMLDNIPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
 
     D RateIn          S             11  7
 
      ** Decimal separator                                                                  MD023981
     D BNDCSP          S              1A                                                    MD023981
                                                                                            MD023981
      ** Parameter list for ZA0840                                                          MD023981
      ** =========================                                                          MD023981
      ** Return code for numeric validation module call                                     MD023981
     D @Rtcde          S             10A                                                    MD023981
      ** Alpha field for numeric validation                                                 MD023981
     D @@ALPH          S             16A                                                    MD023981
      ** Number of decimal places field for numeric validation                              MD023981
     D @@IDP           S              2  0                                                  MD023981
      ** Number of integers field for numeric validation                                    MD023981
     D @@IINT          S              2  0                                                  MD023981
      ** Millions/Thousands id (Y=function on)                                              MD023981
     D @@MTID          S              1A                                                    MD023981
      ** Amount calculation field                                                           MD023981
     D @@AMT           S             15  0                                                  MD023981
      ** Error return code for ZA0840 module                                                MD023981
     D @@ERCD          S              1  0                                                  MD023981
                                                                                            MD023981
     D DSSDY         E DS                  EXTNAME(DSSDY)
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
 
      ** Initialization
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      MsgId1 = *Blanks
     C                   Eval      PWMsgId1 = *Blanks
 
      ** *------------------------------*
      ** * Validate Reference Rate      *
      ** *------------------------------*
 
     C                   Eval      MM#REF = 0
      *
      **  Check it is a valid figure with 8 decimal places max.
 
     C                   Z-ADD     0             @@AMT                                      MD023981
     C                   Z-ADD     0             @@ERCD                                     MD023981
     C     DDRRAT        IFNE      *BLANKS
     C**********         Z-ADD     8             ZADEC
     C**********         Z-ADD     5             ZADIG
     C**********         MOVE      *BLANKS       ZFIELD
     C**********         MOVE      DDRRAT        ZFIELD
     C                   MOVE      *BLANKS       @@ALPH                                     MD023981
     C                   MOVE      DDRRAT        @@ALPH                                     MD023981
     C                   Z-ADD     5             @@IINT                                     MD023981
     C                   Z-ADD     8             @@IDP                                      MD023981
      *
      * Validate alphameric input field as numeric - right-align value in output field
     C**********         CALLB     'ZALIGN'                                                 MD023981
     C**********         PARM                    ZalignOK                                   MD023981
     C**********         PARM                    ZFIELD                                     MD023981
     C**********         PARM                    ZADEC                                      MD023981
     C**********         PARM                    ZADIG                                      MD023981
     C                   CALLB     'ZA0840'                                                 MD023981
     C                   PARM                    @Rtcde                                     MD023981
     C                   PARM                    @@ALPH                                     MD023981
     C                   PARM                    @@IDP                                      MD023981
     C                   PARM                    @@IINT                                     MD023981
     C                   PARM                    @@MTID                                     MD023981
     C                   PARM                    @@ERCD                                     MD023981
     C                   PARM                    @@AMT                                      MD023981
     C                   PARM                    BNDCSP                                     MD023981
 
      **  Set error code if invalid
 
     C**********         If        ZalignOK = 'N'                                           MD023981
     C     @@ERCD        IFEQ      0                                                        MD023981
     C                   Movel     'MMA1337'     MsgId1
     C                   Else
      *
      **  If the rate is valid, set display and file values
      *
     C**********         MOVE      ZFIELD        MM#REF           13 8                      MD023981
     C                   MOVE      @@AMT         MM#REF           13 8                      MD023981
     C                   Z-ADD     MM#REF        RefRate          13 8
      *
      * Convert numeric field - insert decimal point
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC
 
     C                   MOVE      ZFIELD        DDRRAT
      *
      **  Check tolerance
      *
     C                   Z-ADD     *ZERO         MINRAT           13 8
     C                   Z-ADD     *ZERO         MAXRAT           13 8
     C                   Z-ADD     *ZERO         UETOLR           13 8
     C                   Z-ADD     *ZERO         UERRAT           13 8
      *
      **  Set Interest Tolerance
      *
     C                   Eval      UERRAT = (IINRRT/100)
      *
     C     RateIn        MULT(H)   UERRAT        UETOLR
     C     RateIn        SUB(H)    UETOLR        MINRAT
     C     RateIn        ADD(H)    UETOLR        MAXRAT
      *
     C     RateIn        IFNE      0
     C     MM#REF        IFGT      MAXRAT
     C     MM#REF        ANDNE     0
     C     MM#REF        ORLT      MINRAT
     C     MM#REF        ANDNE     0
     C                   Movel     'MMA1336'     PWMsgId1          7
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf                                                  End Valid
     C                   EndIf                                                  End Blank
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      *  Return Code
     C                   Parm                    RetCodeIn
      *  Screen fields
     C                   Parm                    TranInPrim
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    MsgId1            7
     C                   Parm                    PWMsgId1          7
     C                   Parm                    RateIn
     C                   Parm                    RefRate
     C                   PARM                    BNDCSP                                       245692
      *
      * Retrieve Reference Rate Tolerance File
     C     1             SETLL     SDRRATPD
     C                   READ      SDRRATPD                               90
 
      * Record not found
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'SDRRATPD'    DBFILE                         ***************
     C                   MOVEL     '001'         DBASE                          * DB ERROR 001*
     C                   MOVEL     '*FIRST '     DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
