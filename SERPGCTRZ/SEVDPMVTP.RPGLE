     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Repo / Depot Transfer Prim Data')    *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDPMVTP  - Validate Combination of Primary Data            *
      *               of Repos / Data Transfer types.                 *
      *                                                               *
      *  Function:  This module performs the validation if data       *
      *             required for Repos / Data Transfer have the       *
      *             right combination for the transaction type.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. AR1068555          Date 08Feb13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 BUG8910            Date 07Oct05               *
      *                 CAP087  *CREATE    Date 05Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1068555 - Allow amendment of IN date field                 *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG8910 - Make Repo Indicator and Associated Deal            *
      *            optional for Bond Borrowing and Bond Lendings.     *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           (this module was added to srvpgm SP4SE0004)         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
     ** Screen fields
     D DDDPID          S             10A
     D DDDPMD          S              6A
     D DDDPOD          S             10A
     D DDDPDO          S              6A
     D DDDPBA          S              3A
     D DDDPAD          S              6A
     D DDRPIN          S              1A
     D DDPTFR          S              4A
 
      ** System Info
     D DealPreInd      S              1A
 
      ** Work fields
     D ORED            S              5P 0
     D WRunday         S              5P 0
     D WAction         S              1A
     D DPMVType        S              2A
     D*DPID*****       S              6S 0                                                   CSD027A
     D DPID            S              6A                                                     CSD027A
     D DPMD            S              5P 0
     D*DPOD*****       S              6S 0                                                   CSD027A
     D DPOD            S              6A                                                     CSD027A
     D DPDO            S              5P 0
     D DPBA            S              3A
     D DPBK            S              2A
     D DPNA            S             11P 0
     D MKTP            S             15P 8
 
     D*OldDPID**       S              6S 0                                                   CSD027A
     D OldDPID         S              6A                                                     CSD027A
     D OldDPMD         S              5P 0
     D*OldDPOD**       S              6S 0                                                   CSD027A
     D OldDPOD         S              6A                                                     CSD027A
     D OldDPDO         S              5P 0
     D OldDPBA         S              3A
     D OldDPBK         S              2A
     D OldDPNA         S             11P 0
     D OldMKTP         S             15P 8
 
      ** Output fields
      ** -------------
 
     D DDDataOk        S              1A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      ** Validation
      *
     C                   EXSR      SDataC
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDataOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SDataC - Validation Routine for data combination for Repo     *
      *          or Depot Transfer transaction type.                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SDataC        BEGSR
      *
      ** Dealing Module should be present
     C     DealPreInd    IFEQ      'Y'
      *
      ** Check only for Repo or Depot Transfer types
     C     DPMVType      IFEQ      'RR'
     C     DPMVType      OREQ      'RP'
     C     DPMVType      OREQ      'PL'
     C     DPMVType      OREQ      'PD'
     C     DPMVType      OREQ      'BB'
     C     DPMVType      OREQ      'BL'
     C     DPMVType      OREQ      'DT'
      *
      ** In Depot
     C     DDDPID        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPID'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2022'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
      *
      ** In Date
     C     DDDPMD        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2023'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
      *
      ** Out Depot
     C     DDDPOD        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPOD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2024'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   ELSE
      ** Out Depot must not be same as In Depot for DT
     C     DPMVType      IFEQ      'DT'
     C     DDDPOD        ANDEQ     DDDPID
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPOD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2034'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
     C                   END
      *
      ** Out Date (can only be blank for Depot Transfers)
 
     C     DDDPDO        IFEQ      *BLANKS
     C     DPMVType      ANDNE     'DT'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2025'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
     C     DDDPDO        IFNE      *BLANKS
     C     DPMVType      ANDEQ     'DT'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2026'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
      *
      ** Compare In Date and Out Date
      ** (1) Out Date must be later than In Date for BB, RR and PL.
      ** (2) Out Date must be earlier than In Date for BL, RP and PD.
      ** (3) Do not compare for Depot Transfer.
     C     DDDPMD        IFNE      *BLANKS
     C     DDDPDO        ANDNE     *BLANKS
     C     DPMVType      ANDNE     'DT'
 
     C     DPDO          IFGT      DPMD
     C     DPMVType      ANDNE     'BB'
     C     DPMVType      ANDNE     'RR'
     C     DPMVType      ANDNE     'PL'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2032'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
     C     DPDO          IFLT      DPMD
     C     DPMVType      ANDNE     'BL'
     C     DPMVType      ANDNE     'RP'
     C     DPMVType      ANDNE     'PD'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2033'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
     C                   END
      *
      ** Associated Deal Number :
      ** (1) Should be blank for Depot Transfer
      ** (2) Should be entered for Repo, Pledge and Bonds
      ** (3) Optional only for Bond Lending and Bond Borrowing                               BUG8910
 
     C     DDDPAD        IFEQ      *BLANKS
     C     DPMVType      ANDNE     'DT'
     C     DPMVType      ANDNE     'BB'                                                      BUG8910
     C     DPMVType      ANDNE     'BL'                                                      BUG8910
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2027'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
     C     DDDPAD        IFNE      *BLANKS
     C     DPMVType      ANDEQ     'DT'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPAD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2028'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
      *
      ** Portfolio Reference should be blank for all types.
 
     C     DDPTFR        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2029'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
      *
      ** Repo/Pledge Indicator
      ** (1) Should be either R, P, or B (for Repos, Pledge and Bonds respectively)
      ** (2) Should be blank for Depot Transfers
      ** (3) Optional only for Bond Borrowing and Bond Lending                               BUG8910
 
     C     DDRPIN        IFEQ      *BLANKS
     C     DPMVType      ANDNE     'DT'
     C     DPMVType      ANDNE     'BB'                                                      BUG8910
     C     DPMVType      ANDNE     'BL'                                                      BUG8910
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2030'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
     C     DDRPIN        IFNE      *BLANKS
     C     DPMVType      ANDEQ     'DT'
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2031'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
      *
     C     DDRPIN        IFEQ      'R'
     C     DPMVType      ANDNE     'RP'
     C     DPMVType      ANDNE     'RR'
      *
     C     DDRPIN        OREQ      'P'
     C     DPMVType      ANDNE     'PL'
     C     DPMVType      ANDNE     'PD'
      *
     C     DDRPIN        OREQ      'B'
     C     DPMVType      ANDNE     'BB'
     C     DPMVType      ANDNE     'BL'
     C                   ADD       1             Idx
     C                   MOVEL     'DDRPIN'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2044'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
      *
     C                   END
      *
     C                   END
      *
      ** During Insert, Booking branch must be entered.
      *
     C     WAction       IFEQ      'I'
     C     DDDPBA        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2040'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
      *
      ** During amendment, check fields that may not be amended
      *
     C     WAction       IFEQ      'A'
     C     ORED          ANDLT     WRunday
 
      * In Depot
     C     OldDPID       IFNE      DPID
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPID'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2035'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
      * In Date
     C     OldDPMD       IFNE      DPMD
     C     DPMVType      ANDNE     'BL'                                                    AR1068555
     C     DPMVType      ANDNE     'RP'                                                    AR1068555
     C     DPMVType      ANDNE     'PD'                                                    AR1068555
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPMD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2036'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
      * Out Date
     C     OldDPDO       IFNE      DPDO
     C     DPMVType      ANDNE     'BB'                                                    AR1068555
     C     DPMVType      ANDNE     'RR'                                                    AR1068555
     C     DPMVType      ANDNE     'PL'                                                    AR1068555
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPDO'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2037'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
      * Booking Branch
     C     OldDPBA       IFNE      DPBA
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0063'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
      * Book Code
     C     OldDPBK       IFNE      DPBK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPBK'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0060'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
      * Nominal Amount
     C     OldDPNA       IFNE      DPNA
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2038'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
      * Market Price
     C     OldMKTP       IFNE      MKTP
     C                   ADD       1             Idx
     C                   MOVEL     'DDMKTP'      FldNamXAr(Idx)
     C                   MOVEL     'MMA2039'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDataOK
     C                   END
 
     C                   END
 
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
 
     C     *ENTRY        PLIST
 
      ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received parameters
      ** -------------------
      ** Screen Fields **
      ** Movement Type (2A)
      ** In Depot (10A)
      ** In Date (6A)
      ** Out Depot (10A)
      ** Out Date (6A)
      ** Associated Deal Number (6A)
      ** Repo / Pledge Indicator (1A)
     C                   PARM                    WAction
     C                   PARM                    DPMVType
     C                   PARM                    DDDPID
     C                   PARM                    DDDPMD
     C                   PARM                    DDDPOD
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPBA
     C                   PARM                    DPID
     C                   PARM                    DPMD
     C                   PARM                    DPOD
     C                   PARM                    DPDO
     C                   PARM                    DPBA
     C                   PARM                    DPBK
     C                   PARM                    DPNA
     C                   PARM                    MKTP
     C                   PARM                    OldDPID
     C                   PARM                    OldDPMD
     C                   PARM                    OldDPOD
     C                   PARM                    OldDPDO
     C                   PARM                    OldDPBA
     C                   PARM                    OldDPBK
     C                   PARM                    OldDPNA
     C                   PARM                    OldMKTP
     C                   PARM                    DDDPAD
     C                   PARM                    DDRPIN
 
      ** System Details
      ** Dealing module indicator (1A)
     C                   PARM                    DealPreInd
     C                   PARM                    ORED
     C                   PARM                    WRunday
 
      ** Returned parameters
      ** -------------------
     ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
