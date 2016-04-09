     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NASP Validate Reference Rate')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  MMVNARRAT  - Validate MM NASP Reference Rate                 *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Reference Rate and confirms if valid.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CDL049  *CREATE    Date 08May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     D TranInPrim    E DS                  EXTNAME(MMNASPPD)
 
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
 
     C     DDRRAT        IFNE      *BLANKS
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDRRAT        ZFIELD
      *
      * Validate alphameric input field as numeric - right-align value in output field
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
      **  Set error code if invalid
 
     C                   If        ZalignOK = 'N'
     C                   Movel     'MMA1337'     MsgId1
     C                   Else
      *
      **  If the rate is valid, set display and file values
      *
     C                   MOVE      ZFIELD        MM#REF           13 8
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
     C                   Movel     'MMA1336'     PWMsgId1
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
(c) Misys International Banking Systems Ltd. 2006
