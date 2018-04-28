     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV validate trade date')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTRDT    - DPMV Validate Trade Date                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 235997             Date 12Sep05               *
      * Midas Release 4.02 -------------------------------------------*
      *  Prev Amend No. 203240             Date 03Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 180597             Date 30Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015  *CREATE    Date 06Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  235997 - Do not invoke ZCHKH if date is invalid (i.e. field  *
      *           DMTD is zero).                                      *
      *           Also do not set Trade Date equal to Depot Movement  *
      *           Date if Depot Movement Date is zero.               *
      *  203240 - Trade date defaulted with "In depot date" instead   *
      *           of Rundate when date in future                      *
      *           Due to Fix 180597 using W#DPMD used in SRVALI       *
      *  180597 - Trade Date should be equal to Backdated Depot       *
      *           Movement Date                                       *
      *  CSE015 - Forward Valued Depot Movements                      *
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
      *
      ** Initialisation
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
      ** Clear output field for Trade Date
      *
     C                   Z-ADD     0             DMTD
      *
      ** If Trade Date is blank, default to Midas Run Date
      *
     C     DDDMTD        IFEQ      *BLANKS
     C                   EXSR      SRDFLT
      *
      ** Otherwise, validate user input
      *
     C                   ELSE
     C                   EXSR      SRVALI
     C                   ENDIF
      *                                                                                       180597
      ** Trade Date should be equal to Depot Movement Date if it                              180597
      ** less than the rundate                                                                180597
      *                                                                                       180597
     C                   EXSR      SRTRAD                                                     180597
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDMTDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Retrun
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRDFLT - Default Trade Date as Midas Date                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRDFLT        BEGSR
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVEL     ZDATE         DDDMTD
     C                   Z-ADD     BJRDNB        DMTD
     C                   Z-ADD     DMTD          W#DPMD                                       203240
      *
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRVALI    - Trade Date Validation                             *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: ZALIGN, ZCHKH, ZDATE1,                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVALI        BEGSR
      *
      ** Check if a valid date is entered
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDDMTD        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
      *
     C     ZALIGNOK      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C                   ENDIF
      *
      ** Invalid Date was entered
      *
     C     ZALIGNOK      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           DDDMTDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDMTD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0508'     MsgIdXAr(Idx)
     C                   GOTO      ESRVALI
     C                   ENDIF
      *
      ** Update Trade Date
      *
     C                   Z-ADD     ZDAYNO        DMTD
      *
      ** Trade Date cannot be earlier than the back-valued period
      *
     C     DMTD          IFLT      BckValDte
     C                   MOVE      'N'           DDDMTDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDMTD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0510'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Trade Date cannot be greater than the Midas Run Date
      *
     C     DMTD          IFGT      BJRDNB
     C                   MOVE      'N'           DDDMTDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDMTD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0508'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Trade Date cannot be greater than the Depot Movement Date
      *
     C                   MOVE      DDDate        ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *                                                                                       180597
     C     *LIKE         DEFINE    ZDAYNO        W#DPMD                                       180597
     C                   Z-ADD     ZDAYNO        W#DPMD                                       180597
      *
     C     DMTD          IFGT      ZDAYNO
     C                   MOVE      'N'           DDDMTDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDMTD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0583'     MsgIdXAr(Idx)
     C                   ENDIF
      ***********                                                                             180597
      ***Output*warning if it is a holiday in local currency                                  180597
      ***********                                                                             180597
     C***********        CALLB     'ZCHKH'                                                    180597
     C***********        PARM      DMTD          ZDAYNO                                       180597
     C***********        PARM                    BJLCCY                                       180597
     C***********        PARM                    BJSLCD                                       180597
     C***********        PARM                    ZIND              1                          180597
      ***********                                                                             180597
     C*****ZIND**        IFEQ      'H'                                                        180597
     C*****DDDMTDOK      IFNE      'N'                                                        180597
     C***********        MOVE      'W'           DDDMTDOK                                     180597
     C***********        ENDIF                                                                180597
     C***********        ADD       1             WIx                                          180597
     C***********        MOVEL     'DDDMTD'      WFldNmXAr(WIx)                               180597
     C***********        MOVEL     'MMA0511'     WMsgIdXAr(WIx)                               180597
     C***********        ENDIF                                                                180597
      *
     C     ESRVALI       ENDSR
      *                                                                                       180597
      *****************************************************************                       180597
      /EJECT                                                                                  180597
      *****************************************************************                       180597
      *                                                               *                       180597
      * SRTRAD    - Trade Date should be equal to Depot Movement      *                       180597
      *             Date if it is less than the rundate               *                       180597
      *                                                               *                       180597
      * Called by: Main program                                       *                       180597
      *                                                               *                       180597
      *****************************************************************                       180597
      *                                                                                       180597
     C     SRTRAD        BEGSR                                                                180597
      *                                                                                       180597
     C     DMTD          IFGT      W#DPMD                                                     180597
     C     W#DPMD        ANDNE     *ZERO                                                      235997
     C                   MOVEL     DDDate        DDDMTD                                       180597
     C                   Z-ADD     W#DPMD        DMTD                                         180597
     C                   ENDIF                                                                180597
      *                                                                                       180597
      ** Output warning if it is a holiday in local currency                                  180597
      *                                                                                       180597
     C                   IF        DMTD <> *ZERO                                              235997
     C                   CALLB     'ZCHKH'                                                    180597
     C                   PARM      DMTD          ZDAYNO                                       180597
     C                   PARM                    BJLCCY                                       180597
     C                   PARM                    BJSLCD                                       180597
     C                   PARM                    ZIND              1                          180597
      *                                                                                       180597
     C     ZIND          IFEQ      'H'                                                        180597
     C     DDDMTDOK      IFNE      'N'                                                        180597
     C                   MOVE      'W'           DDDMTDOK                                     180597
     C                   ENDIF                                                                180597
     C                   ADD       1             WIx                                          180597
     C                   MOVEL     'DDDMTD'      WFldNmXAr(WIx)                               180597
     C                   MOVEL     'MMA0511'     WMsgIdXAr(WIx)                               180597
     C                   ENDIF                                                                180597
     C                   ENDIF                                                                235997
      *                                                                                       180597
     C                   ENDSR                                                                180597
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR    - Program Initialisation Routine                    *
      *                                                               *
      * Called by: Main program                                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Return Code error indicator
      *
     C                   PARM                    RetCodeIn
      *
      ** Received Parameters
      ** -------------------
      *
      ** Trade Date screen field
      *
     C                   PARM                    DDDMTD            6
      *
      ** Depot Movement Date
      *
     C                   PARM                    DDDate            6
      *
      ** ICD / System Input
      ** Rundate, Date Format, Local Currency,
      ** System Location, Back Value period
      *
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BVBVP             3 0
      *
      ** Returned Parameters
      ** -------------------
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Trade Date - OK Flag
      *
     C                   PARM                    DDDMTDOK          1
      *
      ** Trade Date
      *
     C                   PARM                    DMTD              5 0
      *
      **  Calculate the back-valued date
      *
     C     BJRDNB        SUB       BVBVP         BckValDte         5 0
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
