     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Display Controller')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200110 - Midas SD Network Description Maintenance    *
      *                   (Display Controller)                        *
      *                                                               *
      *  Function:  This module coordinates the display screens       *
      *             sequence and the update of a Network record.      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. EML104             Date 05Feb20               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL146             Date 10Jul13               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML104 - Upgrade EML010 to FB Midas 2.1 SP21                 *
      *           Structured field :86:                               *
      *           Add EML104_021, EML104_022                          *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_007, CGL146_008,    *
      *                        CGL146_009, CGL146_010, CGL146_011,    *
      *                        CGL146_012, CGL146_013, CGL146_014     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FSDNWRKL1  IF   E           K DISK    INFSR(*PSSR) RENAME(@EDREJZ:SDNWRKD0)
      ** Midas Message Network Details
      *
     F/COPY OFCPYSRCZ,CGL146_007                                                              CGL146

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Action key Indicators                                                  *
      *                                                                        *
      * KC - Exit Program                                                      *
      * KJ - Delete Record                                                     *
      * KL - Previous Screen                                                   *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
      *

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================
      *

      ** Named constants
      ** ---------------
      *

      ** Arrays and Data Structures
      ** --------------------------
      *

     D PrvFilRcd     E DS                  EXTNAME(SDNWRKPD) PREFIX(PRV_)
      ** Previous Network File Record (i.e. initial state of the record)
      *

     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      ** New Network File Record (i.e. new state after amendments)
     D/COPY OFCPYSRCZ,CGL146_008                                                              CGL146
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *                                                                                       CER030
      ** Short data structure                                                                 CER030
      *                                                                                       CER030
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER030
      *
     D Arr_User        S             50A   DIM(100)                                           CSD101
     D Arr_Unique      S             75A   DIM(100)                                           CSD101
                                                                                              CSD101
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD101
      ** SD data area                                                                         CSD101

      ** Declared variables
      ** ------------------
      *                                                                                       CER030
      ** Variables for CER030                                                                 CER030
      *                                                                                       CER030
     D PRtcd           S              7A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D CER030          S              1A                                                      CER030
      *
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146

      ** Record Key to process (entry parameter)
      *
     D KeyUsed         DS
     D  KeyNWRK                            LIKE(EDNWRK)

      ** SD000403 parameters.                                                                 CSD101
     D PUniq           S             75A                                                      CSD101
     D PInterface      S             20A                                                      CSD101
     D PUser           S             50A                                                      CSD101
     D PUserDesc       S             50A                                                      CSD101
     D PStat           S              1A                                                      CSD101
     D PRecord         S              1A                                                      CSD101
     D PReturnVal      S              7A                                                      CSD101
     D PAUser          S             50A   DIM(100)                                           CSD101
     D PAUniq          S             75A   DIM(100)                                           CSD101
     D PReturnCode     S              7A                                                      CSD101
     D PIDDesc         S             50A                                                      CSD101
     D Ax              S              4S 0                                                    CSD101
     D PAction         S              1A                                                      CSD101
     D PValidList      S             10A   INZ('SDINTFVL')                                    CSD101
     D PLibrary        S             10A                                                      CSD101
     D PIDName         S            100A                                                      CSD101
     D PPass1          S            128A                                                      CSD101
     D PDescr          S           1000A                                                      CSD101
                                                                                              CSD101
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    KeyUsed
     C                   PARM                    ActionCode

      ** Parameter list for screens display modules (Note that the
      ** return code, although being declared, isn't used for the moment)
      *
     C     PSD20012x     PLIST
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    ActionCode
     C                   PARM      ZAPGM         CallerOut        10
     C     *INKC         PARM      *Off          KCIn              1
     C     *INKJ         PARM      *Off          KJIn              1
     C     *INKL         PARM      *INKL         KLIn              1
     C                   PARM                    NewFilRcd
     C/COPY OFCPYSRCZ,CGL146_009                                                              CGL146

      ** Key lists
      *
     C     KSDNWRKL1     KLIST
     C                   KFLD                    KeyNWRK

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** Main loop until F3 taken from any screen
      *  ========================================
 B1  C                   DOU       *INKC

      ** If Action Code = Delete, Message "Press F10"
      *
 B2  C                   IF        ActionCode = 'D'
     C                   MOVE      'USR4005'     ZAMSID
     C                   EXSR      $ZaSndMsg
 E2  C                   ENDIF

      ** -- Display screen according to the current record format number
      *     ------------------------------------------------------------
 B2  C                   SELECT

      ** ---- Display the key screen format
      ** N.B.: The user may have requested to reinput a previously deleted record,
      **       so we need to avoid the updater module to issue an error in Amend mode
      *
 X2  C                   WHEN      CurFormat = 1
     C                   CALLB     'SD200120'    PSD20012x

 B3  C                   IF        ActionCode = 'A'
     C                   EVAL      PrvFilRcd = NewFilRcd
     C/COPY OFCPYSRCZ,CGL146_010                                                              CGL146
 E3  C                   ENDIF

      ** ---- Display the first details screen format
      *
 X2  C                   WHEN      CurFormat = 2
     C                   CALLB     'SD200121'    PSD20012x

      ** ---- Display the second details screen format
      *
 X2  C                   WHEN      CurFormat = 3
     C                   CALLB     'SD200122'    PSD20012x

      ** ---- Display the third details screen format
      *
 X2  C                   WHEN      CurFormat = 4
     C                   CALLB     'SD200123'    PSD20012x

      ** ---- Display the fourth details screen format
      *
 X2  C                   WHEN      CurFormat = 5
     C                   CALLB     'SD200124'    PSD20012x

      ** ---- Display the fifth details screen format
      *
 X2  C                   WHEN      CurFormat = 6
     C                   CALLB     'SD200126'    PSD20012x

      ** ---- Display the Sixth details screen format
      *
 X2  C                   WHEN      CurFormat = 7
     C                   CALLB     'SD200125'    PSD20012x
      *                                                                                       CER030
      ** Display the Seventh details screen format (Extended Narrative                        CER030
      ** Allowed)                                                                             CER030
      *                                                                                       CER030
     C                   WHEN      CurFormat = 8                                              CER030
      *                                                                                       CER030
     C                   IF        EDENRA = 'Y'                                               CER030
     C                   CALLB     'SD200129'    PSD20012x                                    CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Display the Eighth details screen format (Multicash Network)                         CER030
      *                                                                                       CER030
     C                   WHEN      CurFormat = 9                                              CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND EDMCNW = 'Y'                              CER030
     C/COPY WNCPYSRC,EML104_021                                                               EML104
     C                   CALLB     'SD200128'    PSD20012x                                    CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
 E2  C                   ENDSL

      ** -- Action keys management
      *     ----------------------
      ** ---- F3 ==> Exit program
      *
 B2  C                   IF        *INKC
     C                   MOVEL(P)  '*EXIT'       RetCodeOut
     C                   ITER
 E2  C                   ENDIF

      ** ---- F10 ==> Confirm record deletion
      *
 B2  C                   IF        *INKJ
     C                   EXSR      $UpdatRcd
     C                   MOVE      RetCodeIn     RetCodeOut
     C                   LEAVE
 E2  C                   ENDIF

      ** ---- F12 ==> Return to the previous screen
      *
 B2  C                   IF        *INKL

      ** ------ If first displayed format --> Return to the caller
      *
 B3  C                   IF        DspFormat = 0
     C                   MOVEL(P)  '*PRV'        RetCodeOut
     C                   LEAVE

      ** ------ Otherwise return to the previous screen
      *
 X3  C                   ELSE
     C                   SUB       1             DspFormat
     C                   SUB       1             CurFormat
     C                   ITER
 E3  C                   ENDIF

 E2  C                   ENDIF

      ** -- Check if record has to be updated
      *     ---------------------------------

      ** ---- Update record if last record format and not Delete or Enquire
      *
 B2  C                   IF        CurFormat = NbrFormat  AND
     C                             ActionCode <> 'D' AND ActionCode <> 'E'
     C                   EXSR      $UpdatRcd
     C                   MOVE      RetCodeIn     RetCodeOut
     C                   LEAVE

      ** ---- If no need to update yet, display the next screen
      **      Remark: if last format with Enquire action code --> End of module
      *
 X2  C                   ELSE

 B3  C                   IF        CurFormat = NbrFormat AND ActionCode = 'E'
     C                   MOVE      *Blanks       RetCodeOut
     C                   LEAVE
 E3  C                   ENDIF

 B3  C                   IF        CurFormat < NbrFormat
     C                   ADD       1             CurFormat
     C                   ADD       1             DspFormat
 E3  C                   ENDIF

 E2  C                   ENDIF

 E1  C                   ENDDO

      ** Exit module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

      *========================================================================*
      * $UpdatRcd : Update Records                                             *
      *------------------------------------------------------------------------*
     C     $UpdatRcd     BEGSR
      *    ----------    ------
      ** Call the updater
      *
     C                   CALLB     'SD200160'
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      ZAPGM         CallerOut
     C                   PARM                    ActionCode
     C                   PARM                    PrvFilRcd
     C                   PARM                    NewFilRcd
     C/COPY OFCPYSRCZ,CGL146_011                                                              CGL146
      *    ----------    ------
                                                                                              CSD101
     C                   SELECT                                                               CSD101
                                                                                              CSD101
     C                   WHEN      ActionCode = 'I' and EDPROT = '*FTP  '                     CSD101
                                                                                              CSD101
     C                   CLEAR                   PAUser                                       CSD101
     C                   CLEAR                   PAUniq                                       CSD101
     C                   EVAL      PUniq = 'NETWORK_' + EDNWRK                                CSD101
     C                   EVAL      PIDDesc = EDNETD                                           CSD101
     C                   EVAL      PUser = EDSUID                                             CSD101
     C                   EVAL      PUserDesc = EDSUID                                         CSD101
     C                                                                                        CSD101
     C                   CALL      'SD000403'                                                 CSD101
     C                   PARM      *BLANKS       PReturnCode                                  CSD101
     C                   PARM                    PUniq                                        CSD101
     C                   PARM                    PIDDesc                                      CSD101
     C                   PARM      *BLANKS       PInterface                                   CSD101
     C                   PARM                    PUser                                        CSD101
     C                   PARM                    PUserDesc                                    CSD101
     C                   PARM      'I'           PStat                                        CSD101
     C                   PARM      'M'           PRecord                                      CSD101
     C                   PARM      *BLANKS       PReturnVal                                   CSD101
     C                   PARM                    PAUser                                       CSD101
     C                   PARM                    PAUniq                                       CSD101
                                                                                              CSD101
     C                   WHEN      ActionCode = 'A' and EDPROT = '*FTP  '                     CSD101
                                                                                              CSD101
     C                   IN        SDSTAT                                                     CSD101
                                                                                              CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PIDName = 'NETWORK_' + EDNWRK                              CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *BLANKS       PReturnCode                                  CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM      *BLANKS       PPass1                                       CSD101
     C                   PARM      *BLANKS       PDescr                                       CSD101
                                                                                              CSD101
     C                   IF        PReturnCode = *BLANKS                                      CSD101
     C                   CLEAR                   PAUser                                       CSD101
     C                   CLEAR                   PAUniq                                       CSD101
     C                   EVAL      PUniq = 'NETWORK_' + EDNWRK                                CSD101
     C                   EVAL      PUser = EDSUID                                             CSD101
     C                                                                                        CSD101
     C                   CALL      'SD000403'                                                 CSD101
     C                   PARM      *BLANKS       PReturnCode                                  CSD101
     C                   PARM                    PUniq                                        CSD101
     C                   PARM      *BLANKS       PIDDesc                                      CSD101
     C                   PARM      *BLANKS       PInterface                                   CSD101
     C                   PARM                    PUser                                        CSD101
     C                   PARM      *BLANKS       PUserDesc                                    CSD101
     C                   PARM      'A'           PStat                                        CSD101
     C                   PARM      'M'           PRecord                                      CSD101
     C                   PARM      *BLANKS       PReturnVal                                   CSD101
     C                   PARM                    PAUser                                       CSD101
     C                   PARM                    PAUniq                                       CSD101
                                                                                              CSD101
     C                   ELSE                                                                 CSD101
                                                                                              CSD101
     C                   CLEAR                   PAUser                                       CSD101
     C                   CLEAR                   PAUniq                                       CSD101
     C                   EVAL      PUniq = 'NETWORK_' + EDNWRK                                CSD101
     C                   EVAL      PIDDesc = EDNETD                                           CSD101
     C                   EVAL      PUser = EDSUID                                             CSD101
     C                   EVAL      PUserDesc = EDSUID                                         CSD101
     C                                                                                        CSD101
     C                   CALL      'SD000403'                                                 CSD101
     C                   PARM      *BLANKS       PReturnCode                                  CSD101
     C                   PARM                    PUniq                                        CSD101
     C                   PARM                    PIDDesc                                      CSD101
     C                   PARM      *BLANKS       PInterface                                   CSD101
     C                   PARM                    PUser                                        CSD101
     C                   PARM                    PUserDesc                                    CSD101
     C                   PARM      'I'           PStat                                        CSD101
     C                   PARM      'M'           PRecord                                      CSD101
     C                   PARM      *BLANKS       PReturnVal                                   CSD101
     C                   PARM                    PAUser                                       CSD101
     C                   PARM                    PAUniq                                       CSD101
                                                                                              CSD101
     C                   ENDIF                                                                CSD101
                                                                                              CSD101
     C                   WHEN      ActionCode = 'D' and EDPROT = '*FTP  '                     CSD101
                                                                                              CSD101
     C                   EVAL      Ax = 1                                                     CSD101
     C                   CLEAR                   Arr_User(Ax)                                 CSD101
     C                   CLEAR                   Arr_Unique(Ax)                               CSD101
                                                                                              CSD101
     C                   EVAL      Arr_User(Ax) = %TRIM(EDSUID)                               CSD101
     C                   EVAL      Arr_Unique(Ax) = %TRIM('NETWORK_' + EDNWRK)                CSD101
                                                                                              CSD101
     C                   MOVEA     Arr_User      PAUser                                       CSD101
     C                   MOVEA     Arr_Unique    PAUniq                                       CSD101
                                                                                              CSD101
     C                   CALL      'SD000403'                                                 CSD101
     C                   PARM      *BLANKS       PReturnCode                                  CSD101
     C                   PARM      *BLANKS       PUniq                                        CSD101
     C                   PARM      *BLANKS       PIDDesc                                      CSD101
     C                   PARM      *BLANKS       PInterface                                   CSD101
     C                   PARM      *BLANKS       PUser                                        CSD101
     C                   PARM      *BLANKS       PUserDesc                                    CSD101
     C                   PARM      'D'           PStat                                        CSD101
     C                   PARM      'M'           PRecord                                      CSD101
     C                   PARM      *BLANKS       PReturnVal                                   CSD101
     C                   PARM                    PAUser                                       CSD101
     C                   PARM                    PAUniq                                       CSD101
                                                                                              CSD101
     C                   ENDSL                                                                CSD101
                                                                                              CSD101
     C     @UpdatRcd     ENDSR

      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR

      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Commit eventual changes if all's right
      *
     C                   IF        RetCodeOut = *Blanks AND ActionCode <> 'E'
     C                   COMMIT
     C                   ENDIF

      ** Always roll back and exit
      *
     C                   ROLBK
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80

      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10

      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF
     C/COPY OFCPYSRCZ,CGL146_014                                                              CGL146

     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7

      ** Reset fields
      *
     C                   CLEAR                   PrvFilRcd
     C                   CLEAR                   NewFilRcd
     C/COPY OFCPYSRCZ,CGL146_012                                                              CGL146

      ** Set up screen format flag according to the received action code
      *
      ** -- First details format if Amend, Enquire, or Delete
      *
     C                   IF        ActionCode = 'A' OR ActionCode = 'E' OR
     C                             ActionCode = 'D'
     C                   Z-ADD     2             CurFormat         2 0

      ** -- Otherwise key format
      *
     C                   ELSE
     C                   Z-ADD     1             CurFormat
     C                   ENDIF

      ** Set up the number of the last format to process before amending the file record
      *
     C**********         Z-ADD     7             NbrFormat         2 0                        CER030
     C                   Z-ADD     9             NbrFormat         2 0                        CER030

      ** Set up the count of displayed formats since the first
      ** This field will be mainly used for F12 management
      *
     C                   Z-ADD     0             DspFormat         2 0

      ** If not Insert, check if record exists
      *
 B1  C                   IF        ActionCode <> 'I'
     C     KSDNWRKL1     CHAIN     SDNWRKD0                           99

      ** -- Record not found --> Error
      *
 B2  C                   IF        *IN99
     C                   MOVE      'USR4003'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   EXSR      $ExitMod

      ** -- Check if record is live
      *
 X2  C                   ELSE

      ** ---- If record deleted and not Enquire --> Error
      *
 B3  C                   IF        EDTYLC = 'D' AND ActionCode <> 'E'
     C                   MOVE      'USR4004'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   EXSR      $ExitMod

      ** ---- Save the current value of the record
      *
 X3  C                   ELSE
     C                   MOVE      NewFilRcd     PrvFilRcd
     C/COPY OFCPYSRCZ,CGL146_013                                                              CGL146
 E3  C                   ENDIF

 E2  C                   ENDIF

 E1  C                   ENDIF
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
      *                                                                                       CER030
      ** Check the switchable feature CER030 with the corresponding                           CER030
      ** parameters.                                                                          CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF and blanks)                              CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF' AND                                        CER030
     C                             PRtcd <> *BLANKS                                           CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 1                                                  CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C/COPY WNCPYSRC,EML104_022                                                               EML104
      *    ----------    ------
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On

     C                   CALLB     'DBERRCTL'

     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
