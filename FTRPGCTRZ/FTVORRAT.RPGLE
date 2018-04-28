     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT OPAY Validate Reference Rate')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVORRAT  - Validate Reference Rate                          *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Reference Rate and confirms if it is valid.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 30Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049  *CREATE    Date 03May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate.                *
      *  CDL049 - Addition of Reference Rate. API processing.         *
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
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Warning in error.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of Warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of Warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
                                                                                              255711
      ** Payment Extension Details layout                                                     255711
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                                 255711
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
 
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
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr = *Blanks
     C                   Eval      WMsgDtaXAr= *Blanks
     C                   Eval      Idx = 0
     C                   Eval      WIx = 0
 
      ** *------------------------------*
      ** * Validate Reference Rate      *
      ** *------------------------------*
 
     C                   Eval      FT#REF = 0
      *
      **  Check it is a valid figure with 8 decimal places max.
      *
     C     SRRAT         IFNE      *BLANKS
     C                   Z-ADD     8             ZADEC
     C                   Z-ADD     5             ZADIG
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      SRRAT         ZFIELD
      *
      * Validate alphameric input field as numeric - right-align value in output field
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
      **  Set error code if invalid
 
     C                   If        ZalignOK = 'N'
      * Send error to screen
     C                   Add       1             Idx
     C                   Movel     'SRRAT'       FldNamXAr(Idx)
     C                   Movel     'FTM1321'     MsgIdXAr(Idx)
     C                   Else
      *
      **  If the rate is valid, set display and file values
      *
     C                   MOVE      ZFIELD        FT#REF           13 8
     C                   Z-ADD     FT#REF        RefRate          13 8
      *
      * Convert numeric field - insert decimal point
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC
 
     C                   MOVE      ZFIELD        SRRAT
      *
      **  Check tolerance
      *
     C                   Z-ADD     *ZERO         MINRAT           13 8
     C                   Z-ADD     *ZERO         MAXRAT           13 8
     C                   Z-ADD     *ZERO         UETOLR           13 8
     C                   Z-ADD     *ZERO         UERRAT           13 8
      *
      **  Set FX Tolerance
      *
     C                   Eval      UERRAT = (IRATET/100)
      *
     C     @RATE         MULT(H)   UERRAT        UETOLR
     C     @RATE         SUB(H)    UETOLR        MINRAT
     C     @RATE         ADD(H)    UETOLR        MAXRAT
      *
     C     @RATE         IFNE      0
     C     FT#REF        IFGT      MAXRAT
     C     FT#REF        ANDNE     0
     C     FT#REF        ORLT      MINRAT
     C     FT#REF        ANDNE     0
      * Send error to screen
     C                   Add       1             WIx
     C                   Movel     'SRRAT'       WFldNmXAr(WIx)
     C                   Movel     'FTM1320'     WMsgIdXAr(WIx)
     C                   EndIf
     C                   EndIf
      *
     C                   EndIf                                                  End Valid
     C                   EndIf                                                  End Blank
      *
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
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB                                   255711
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C                   Parm                    RefRate
      *
      * Retrieve Reference Rate Tolerance File
     C     1             SETLL     SDRRATPD
     C                   READ      SDRRATPD                               90
      *
      * Record not found
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'SDRRATPD'    DBFILE                         ***************
     C                   MOVEL     '001'         DBASE                          * DB ERROR 001*
     C                   MOVEL     '*FIRST '     DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
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
