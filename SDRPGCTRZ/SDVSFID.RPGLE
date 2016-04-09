     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate SWIFT ID')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVSFID  - Validate SWIFT ID                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR855391           Date 27Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. 196833             Date 16Aug01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 01Apr99               *
      *                                                               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2)                                  *
      *  196833 - Additional SWIFT Address for CLS Nostros. Wrong     *
      *           return code checked after ME1400. Program based on  *
      *           this module was created for the use of OPM programs.*
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
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
     DSDCNST         E DS                  EXTNAME(SDCNSTPD)
     DSDCUST           DS           520
      ** DS for currency details
     DMEBICD         E DS                  EXTNAME(MEBICDPD)
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
                                                                                            AR855391
      ** Index for arrays of warning message ids etc                                        AR855391
     D WIdx            S              3P 0                                                  AR855391
 
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
                                                                                            AR855391
     C                   MOVE      *BLANK        WFldNmXAr                                  AR855391
     C                   MOVE      *BLANK        WMsgIDXAr                                  AR855391
     C                   MOVE      *BLANK        WMsgDtXAr                                  AR855391
     C                   Z-ADD     0             WIdx                                       AR855391
      *
      ** VALIDATION
      *
     C                   EXSR      CSIDV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCSIDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *                                                                                     AR855391
     C     DDCSIDOK      IFEQ      'W'                                                      AR855391
     C                   EVAL      RetCodeIn = 'Warning'                                    AR855391
     C                   ENDIF                                                              AR855391
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     CSIDV         BEGSR
 
      * If SWIFT ID is entered
     C     DDCSID        IFNE      *BLANK
 
      * if module MIDAS/SWIFT direct link is ON
     C     BGMSDL        IFEQ      'Y'
 
      * call program with SWIFT ID validation parameters
     C                   CALL      'SD0011U1'                           90
      ** Return Code (7A)
      ** SWIFT ID (12A)
      ** 10 Characters (1A)
      ** First 6 Characters all Alpha (1A)
      ** Invalid Characters (1A)
      ** Less than 8 Characters (1A)
      ** Embedded Spaces (1A)
      ** Not 8 or 11 Characters (1A)
     C                   PARM                    @RTCD             7
     C                   PARM      DDCSID        DDCSID
     C                   PARM      *BLANK        WKSICL            1
     C                   PARM      *BLANK        WKC6NL            1
     C                   PARM      *BLANK        WKINVC            1
     C                   PARM      *BLANK        WKSIL8            1
     C                   PARM      *BLANK        WKEMSP            1
     C                   PARM      *BLANK        WKBICL            1
      * First 6 characters must be all alpha
     C     WKC6NL        IFEQ      '1'
     C**********         MOVE      'N'           DDCSIDOK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCSID'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR0773'     MsgIdXAr(Idx)                              AR855391
     C                   MOVE      'W'           DDCSIDOK                                   AR855391
     C                   ADD       1             WIdx                                       AR855391
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCSID'                               AR855391
     C                   EVAL      WMsgIdXAr(WIdx) = 'USR0773'                              AR855391
     C                   END
      * No invalid characters may be entered
     C     WKINVC        IFEQ      '1'
     C**********         MOVE      'N'           DDCSIDOK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCSID'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR0775'     MsgIdXAr(Idx)                              AR855391
     C                   MOVE      'W'           DDCSIDOK                                   AR855391
     C                   ADD       1             WIdx                                       AR855391
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCSID'                               AR855391
     C                   EVAL      WMsgIdXAr(WIdx) = 'USR0775'                              AR855391
     C                   END
      * ID may have no embedded spaces
     C     WKEMSP        IFEQ      '1'
     C**********         MOVE      'N'           DDCSIDOK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCSID'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR0771'     MsgIdXAr(Idx)                              AR855391
     C                   MOVE      'W'           DDCSIDOK                                   AR855391
     C                   ADD       1             WIdx                                       AR855391
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCSID'                               AR855391
     C                   EVAL      WMsgIdXAr(WIdx) = 'USR0771'                              AR855391
     C                   END
      * ID must be 8 or 11 characters in length
     C     WKSICL        IFEQ      '1'
     C     WKSIL8        OREQ      '1'
     C     WKBICL        OREQ      '1'
     C                   MOVE      'N'           DDCSIDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSID'      FldNamXAr(Idx)
     C                   MOVEL     'USR1141'     MsgIdXAr(Idx)
     C                   END
 
 
      * Otherwise (i.e. module MIDAS/SWIFT direct link is OFF)
     C                   ELSE
 
      * SWIFT ID must be blank
     C                   MOVE      'N'           DDCSIDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSID'      FldNamXAr(Idx)
     C                   MOVEL     'USR1419'     MsgIdXAr(Idx)
     C                   END
 
     C                   MOVEL     DDCSID        WKCSID8
     C                   MOVE      DDCSID        WKCSID4           4
     C                   MOVEL     WKCSID4       WKCSID3
 
      * Call program to validate ID
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       WKBICR            7
     C                   PARM                    WKCSID8           8
     C                   PARM                    WKCSID3           3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       WKBICC            1
     C                   PARM      *BLANKS       WKBICS            1
     C                   PARM      *BLANKS       WKBICI            1
 
      * BIC identifier not found
     C*****@RTCD         IFEQ      'MIN0244'                                                  196833
     C*****@RTCD         OREQ      'MIN0245'                                                  196833
     C*****@RTCD         OREQ      'MIN0246'                                                  196833
     C     WKBICR        IFEQ      'MIN0244'                                                  196833
     C     WKBICR        OREQ      'MIN0245'                                                  196833
     C     WKBICR        OREQ      'MIN0246'                                                  196833
     C**********         MOVE      'N'           DDCSIDOK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCSID'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR2241'     MsgIdXAr(Idx)                              AR855391
     C                   MOVE      'W'           DDCSIDOK                                   AR855391
     C                   ADD       1             WIdx                                       AR855391
     C                   EVAL      WFldNmXAr(WIdx) = 'DDCSID'                               AR855391
     C                   EVAL      WMsgIdXAr(WIdx) = 'USR2241'                              AR855391
     C                   END
 
     C                   END
 
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
      ** Customer SWIFT ID (12A)
      ** MIDAS/SWIFT direct link (1A)
     C                   PARM                    DDCSID           12
     C                   PARM                    BGMSDL            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                     AR855391
      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR855391
     C                   PARM                    WFldNmXAr                                  AR855391
     C                   PARM                    WMsgIDXAr                                  AR855391
     C                   PARM                    WMsgDtXAr                                  AR855391
      *
      ** SWIFT ID - OK
     C                   PARM                    DDCSIDOK          1
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
