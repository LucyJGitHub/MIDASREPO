     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Capacity')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTCAPACI - Validate Trade Capacity                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP003  *CREATE    Date 23Feb98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** trade capacity ind
     D TCAP            S              1S 0
 
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output trade fields
 
     C                   Z-ADD     *ZERO         TCAP
      *
      ** DEFAULTING
      *
     C     Default       IFEQ      'Y'
     C     DDCPCY        ANDEQ     *BLANK
     C                   EXSR      CPCYD
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      CPCYV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCpcyOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     CPCYV         BEGSR
      *
      * Capacity
      *
      *    .. if entered, must be in the range 0 - 6
      *
     C     DDCPCY        IFNE      *BLANKS
     C     DDCPCY        IFLT      '0'
     C     DDCPCY        ORGT      '6'
     C                   MOVE      'N'           DDCpcyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCPCY'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0506'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
      *  If Bulk Agency Trade  ........
      *
     C     DDCpcyOK      IFEQ      'Y'
      *
     C     DDBLKR        IFNE      *BLANKS
     C     ATRD          ANDNE     *BLANKS
     C     BVBIOP        ANDEQ     'Y'
      *
      *  Only Capacity 3,6,1,4 and 0 are valid  ....
     C     DDCPCY        IFNE      '3'
     C     DDCPCY        ANDNE     '6'
     C     DDCPCY        ANDNE     '1'
     C     DDCPCY        ANDNE     '4'
     C     DDCPCY        ANDNE     '0'
     C                   MOVE      'N'           DDCpcyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCPCY'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0506'     MsgIdXAr(Idx)
     C                   END
     C                   END
     C                   END
     C*
     C*  CHECK COMPATIBILITY OF CAPACITY IND. WITH TRADE TYPE.
     C*
     C     DDTDTP        IFEQ      'TP'
     C     DDCPCY        ANDEQ     '2'
     C     DDTDTP        OREQ      'TP'
     C     DDCPCY        ANDEQ     '3'
     C     DDTDTP        OREQ      'TS'
     C     DDCPCY        ANDEQ     '5'
     C     DDTDTP        OREQ      'TS'
     C     DDCPCY        ANDEQ     '6'
     C                   MOVE      'N'           DDCpcyOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCPCY'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0507'     MsgIdXAr(Idx)
     C                   END
      *
      * Update trade
      *
     C     DDCPCY        IFNE      *BLANKS
     C     DDCpcyOK      ANDNE     'N'
     C                   MOVE      DDCPCY        TCAP
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DEFAULTING
      *****************************************************************
     C     CPCYD         BEGSR
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDCPCY            1
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDTDTP            2
      *
      ** Agency trade ID
      ** Bulk input option
     C                   PARM                    ATRD              1
     C                   PARM                    BVBIOP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Capacity Ind. - OK
     C                   PARM                    DDCpcyOK          1
      *
      ** Capacity Ind.
      *
     C                   PARM                    TCAP
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
