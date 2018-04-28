     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade order details retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADORTV - SE Trade Order Details Retrieve Module          *
      *                                                               *
      *  Function:  This module checks whether the fields input on    *
      *             SETRADDDSP are valid, that is the action code,    *
      *             the order number and the review trades fields.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE019             Date 05Apr00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CSE010  *CREATE    Date 21Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE019 - SE Trades Selections Enhancements                   *
      *  CSE010 - SE Transactions Enhancements                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FTRADSDL9  IF   E           K DISK    INFSR(*PSSR)
     FSETRADL0  IF   E           K DISK    INFSR(*PSSR)                         CSE019
     FMUSER     IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities Trading ICD Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger ICD Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS fpr Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Ix              S              3P 0
      ** Index for arrays of of error message ids etc
                                                                                CSE019
      ** Data structure to define Front Office Id                               CSE019
     D                 DS                                                       CSE019
     D WWFRNT                  1     20A                                        CSE019
     D W1ORDE                  1     16A                                        CSE019
     D WWSTID                  1      2A                                        CSE019
     D WWDATE                  3     10A                                        CSE019
     D WWORDE                 11     16A                                        CSE019
     D WWORNO                 17     20A                                        CSE019
                                                                                CSE019
     D                 DS                                                       CSE019
     D W2FRNT                  1     20A                                        CSE019
     D W2ORDE                  1     16A                                        CSE019
                                                                                CSE019
      ** Formatted date field for use in the parameter list                     CSE019
     D DateIn          S              6A                                        CSE019
     D DaynoOut        S              5P 0                                      CSE019
     D ErrorFlag       S              1A                                        CSE019
                                                                                CSE019
      ** Formatted date field for use in the parameter list                     CSE019
     D Dayin           S              5P 0                                      CSE019
     D Dayout          S              8S 0                                      CSE019
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
     C                   EXSR      VAL
      *
      ** Carry out no further validation if errors have occur
      *
     C                   If        OKACTN = 'N' or OKORDE = 'N'
     C                             or OKDATE = 'N' or OKSTID = 'N'              CSE019
     C                             or OKREVW = 'N'
     C                   RETURN
     C                   Endif
      *
      ** Chain to SE Trades by Order Number
      *
     C     CSE019        IFEQ      'Y'                                          CSE019
     C                   Movel     DDSTID        WWSTID                         CSE019
     C                   Movel     DDORDE        WWORDE                         CSE019
     C                   Movel     *Zeros        WWORNO                         CSE019
     C                   Movel     WWFRNT        DDFRNT           20            CSE019
      *                                                                         CSE019
     C     WWFRNT        Setll     SETRADL0                                     CSE019
     C                   Read      SETRADL0                               23    CSE019
      *                                                                         CSE019
     C     *in23         Ifeq      *OFF                                         CSE019
     C                   Movel     FRNT          W2FRNT                         CSE019
     C     W1ORDE        Ifne      W2ORDE                                       CSE019
     C                   Move      *ON           *in23                          CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
     C                   ELSE                                                   CSE019
     C                   MOVE      DDORDE        WORDE             6 0
     C     WORDE         CHAIN     @TRADL9                            23
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
     C                   If        *IN23 = *ON
     C                   MOVE      'N'           OKORDE
     C                   ADD       1             Ix
     C                   MOVEL     'DDORDE'      FldNameArr(Ix)
     C**********         MOVEL     'SEW1009'     MsgIdArr(Ix)                   CSE019
     C                   MOVEL     'SEW1031'     MsgIdArr(Ix)                   CSE019
     C                   Endif
      *
      ** Carry out no further validation if errors have occur
      *
     C                   If        OKORDE = 'N'
     C                   RETURN
     C                   Endif
      *
      ** Check if Single Branching or not
      *
     C                   If        BJSBRC <> *Blanks
     C                   EXSR      ACSSES
     C                   Else
     C                   EXSR      ACSSEM
     C                   Endif
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation                                              *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
      *
     C     VAL           BEGSR
      *
      ** Check if Action Code is valid
      *
     C                   IF        DDACTN <> 'E' and DDACTN <> 'D'
     C                             and DDACTN <> 'Y' and DDACTN <> 'P'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C**********         MOVEL     'SEW1010'     MsgIdArr(Ix)                   CSE019
     C                   MOVEL     'SEW1032'     MsgIdArr(Ix)                   CSE019
     C                   ENDIF
      *
      ** If Action Code is Authorise
      *
     C                   IF        DDACTN = 'Y'
      *
      ** If Trade Authorisation is not selected on the Securities Trading
      ** ICD
      *
     C                   IF        BVAUTH = '00'
     C                   MOVE      'N'           OKACTN
     C                   Add       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SEW1004'     MsgIdArr
     C                   ENDIF
      *
      ** If Trade Authorisation is authorisation by re-entering
      *
     C                   IF        BVAUTH = '15'
     C                   MOVE      'N'           OKACTN
     C                   Add       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SEW1004'     MsgIdArr(Ix)
     C                   Endif
     C                   ENDIF
      *
      ** If Action Code is Approve and Trade Authorisation is not
      ** authorisation by review and approval
      *
     C                   IF        DDACTN = 'P' and BVAUTH <> '20'
     C                   MOVE      'N'           OKACTN
     C                   Add       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C**********         MOVEL     'SEW1011'     MsgIdArr(Ix)                   CSE019
     C                   MOVEL     'SEW1033'     MsgIdArr(Ix)                   CSE019
     C                   ENDIF
      *                                                                         CSE019
      ** If System Id is not entered                                            CSE019
      *                                                                         CSE019
     C                   If        DDSTID = *Blanks                             CSE019
     C                             And CSE019 = 'Y'                             CSE019
     C                   Move      'N'           OKSTID                         CSE019
     C                   Add       1             Ix                             CSE019
     C                   Movel     'DDSTID'      FldNameArr(Ix)                 CSE019
     C                   Movel     'SEW1024'     MsgIdArr(Ix)                   CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      ** If Date is not entered                                                 CSE019
      *                                                                         CSE019
     C                   If        DDDATE = *Blanks                             CSE019
     C                             And CSE019 = 'Y'                             CSE019
     C                   Move      'N'           OKDATE                         CSE019
     C                   Add       1             Ix                             CSE019
     C                   Movel     'DDDATE'      FldNameArr(Ix)                 CSE019
     C                   Movel     'SEW1025'     MsgIdArr(Ix)                   CSE019
     C                   Endif                                                  CSE019
      *                                                                         CSE019
      ** If Date is entered, must be a valid format date                        CSE019
      *                                                                         CSE019
     C                   If        DDDATE <> *Blanks                            CSE019
     C                             And CSE019 = 'Y'                             CSE019
     C                   Callb     'ZDATE1'                                     CSE019
     C                   Parm      DDDATE        DateIn                         CSE019
     C                   Parm                    DaynoOut                       CSE019
     C                   Parm                    BJDFIN                         CSE019
     C                   Parm                    ErrorFlag                      CSE019
      *                                                                         CSE019
     C     ErrorFlag     Ifeq      'N'                                          CSE019
      *                                                                         CSE019
     C                   Z-add     DaynoOut      DayIn                          CSE019
      *                                                                         CSE019
      *** Transform Date Format DDMMYY to DDMMYYYY                              CSE019
      *                                                                         CSE019
     C                   Callb     'ZDATE9'                                     CSE019
     C                   Parm                    DayIn                          CSE019
     C                   Parm      *Zeros        DayOut                         CSE019
     C                   Parm      *Zeros        RetCode           1            CSE019
      *                                                                         CSE019
     C                   Movel     Dayout        WWDATE                         CSE019
     C                   Else                                                   CSE019
     C                   Move      'N'           OKDATE                         CSE019
     C                   Add       1             Ix                             CSE019
     C                   Movel     'DDDATE'      FldNameArr(Ix)                 CSE019
     C                   Movel     'SEW1026'     MsgIdArr(Ix)                   CSE019
     C                   Endif                                                  CSE019
     C                   Endif                                                  CSE019
      *
      ** If Order Number is not blanks
      *
     C                   IF        DDORDE <> *Blanks
     C                   TESTN                   DDORDE               30
     C     *IN30         IFEQ      *OFF
     C                   MOVE      'N'           OKORDE
     C                   Add       1             Ix
     C                   MOVEL     'DDORDE'      FldNameArr(Ix)
     C                   MOVEL     'SEW1012'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** Default Review Trade to Yes if Action Code is Enquiry                  CSE019
      *                                                                         CSE019
     C                   IF        DDACTN = 'E'                                 CSE019
     C                             AND CSE019 = 'Y'                             CSE019
     C                   MOVE      'Y'           DDREVW                         CSE019
     C                   ENDIF                                                  CSE019
      *                                                                         CSE019
      ** IF Review Trade is not Yes or No
      *
     C                   IF        DDREVW <> 'Y' and DDREVW <> 'N'
     C                   MOVE      'N'           OKREVW
     C                   Add       1             Ix
     C                   MOVEL     'DDREVW'      FldNameArr(Ix)
     C                   MOVEL     'SEW1013'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - Access Security Multi-Branch                         *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     ZVACTU - Validate action Code for User/Pgm         *
      *                                                               *
      *****************************************************************
     C     ACSSES        BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SEM1019'     MsgIdArr(Ix)
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEM - Access Security Checking - Multi-Branch              *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     ZVACTBU - Validate Action Code by User/Pgm/Branch  *
      *                                                               *
      *****************************************************************
     C     ACSSEM        BEGSR
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM      TDBA          ZBR               3
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   MOVEL     'N'           OKORDE
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SEM1021'     MsgIdArr(Ix)
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   MOVEL     'N'           OKORDE
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SEM1021'     MsgIdArr(Ix)
     C                   END
     C                   END
      *
      ** If Originating Branch used = 'Y',
      ** &  Originating Branch/User Validation = 'Y'
      ** Check user's authority for the Originating Branch.
      *
     C     BKOBRU        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          ZOBRX             3
     C                   PARM                    ERR               1 0
      *
      ** If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   MOVEL     'N'           OKORDE
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SEM1055'     MsgIdArr(Ix)
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   MOVEL     'N'           OKORDE
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SEM1056'     MsgIdArr(Ix)
     C                   END
     C                   END
     C                   END
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION                                         *
      *                                                               *
      * Called By: MAIN                                               *
      *                                                               *
      * Calls:     None                                               *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKSTID                         CSE019
     C                   MOVEL     'Y'           OKDATE                         CSE019
     C                   MOVEL     'Y'           OKORDE
     C                   MOVEL     'Y'           OKREVW
      *
     C                   ENDSR
     C********************************************************************
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
      ** Input Parameters
      *
      * Return code
      ** Action Code
      ** System Id                                                              CSE019
      ** Date                                                                   CSE019
      ** Order Number
      ** Review Trade
      *
     C                   PARM                    RetrnCod          6
     C                   PARM                    DDACTN            1
     C                   PARM                    DDSTID            2            CSE019
     C                   PARM                    DDDATE            6            CSE019
     C                   PARM                    DDORDE            6
     C                   PARM                    DDREVW            1
     C                   PARM                    CSE019            1            CSE019
      *
      ** Output Parameters
      ** Action Code OK
      ** System Id OK                                                           CSE019
      ** Date OK                                                                CSE019
      ** Order Number OK
      ** Review Trade OK
      ** Date number                                                            CSE019
      ** Error fields array
      ** Message Ids Array
      ** Message data array
      *
     C                   PARM                    OKACTN            1
     C                   PARM                    OKSTID            1            CSE019
     C                   PARM                    OKDATE            1            CSE019
     C                   PARM                    OKORDE            1
     C                   PARM                    OKREVW            1
     C                   PARM                    DDFRNT                         CSE019
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM                    Ix
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADORTV'  DBPGM
      *
      ** Access Bankd Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Securities Trading Details
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access General Ledger ICD Details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access MIDAS User Details
      *
     C     PSUser        CHAIN     MUSER                              99
      *
      ** Database Error
      *
     C     *IN99         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   MOVEL     'MUSERDD '    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     PSUser        DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Execute Initial Subroutine
      *
     C                   EXSR      INIT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
