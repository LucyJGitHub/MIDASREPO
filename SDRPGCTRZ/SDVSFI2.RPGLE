     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate SWIFT ID 2')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVSFI2  - Validate SWIFT ID 2                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  NOTE: This module is based over SDVSFID, any change to the   *
      *        latter may have to be applied to this module too.      *
      *                                                               *
      *  Last Amend No. AR855391           Date 27Oct11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSW036  *CREATE    Date 15Dec04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *             (CSD091 - Overrideable Errors Configurability     *
      *             Enabler Phase 2)                                  *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
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
     D WIx             S              3P 0                                                  AR855391
 
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
     C                   MOVE      *BLANK        WFldNmXAr                                  AR855391
     C                   MOVE      *BLANK        WMsgIDXAr                                  AR855391
     C                   MOVE      *BLANK        WMsgDtXAr                                  AR855391
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIx                                        AR855391
      *
      ** VALIDATION
      *
     C                   EXSR      CSI2V
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCSI2OK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C     DDCSI2OK      IFEQ      'W'                                                      AR855391
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
     C     CSI2V         BEGSR
 
      * If SWIFT ID is entered
     C     DDCSI2        IFNE      *BLANK
 
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
     C                   PARM      DDCSI2        DDCSI2
     C                   PARM      *BLANK        WKSICL            1
     C                   PARM      *BLANK        WKC6NL            1
     C                   PARM      *BLANK        WKINVC            1
     C                   PARM      *BLANK        WKSIL8            1
     C                   PARM      *BLANK        WKEMSP            1
     C                   PARM      *BLANK        WKBICL            1
      *
      * Second Swift ID must be entered only if first Swift ID has been entered and OK
     C     DDCSIDOK      IFNE      'Y'
     C     DDCSI2        ANDNE     *BLANKS
     C     DDCSIDOK      OREQ      'Y'
     C     DDCSID        ANDEQ     *BLANKS
     C     DDCSI2        ANDNE     *BLANKS
     C                   MOVE      'N'           DDCSI2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSI2'      FldNamXAr(Idx)
     C                   MOVEL     'USR8977'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      * Second Swift ID must be different from First Swift ID, if entered
     C     DDCSI2        IFNE      *BLANKS
     C     DDCSI2        ANDEQ     DDCSID
     C                   MOVE      'N'           DDCSI2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSI2'      FldNamXAr(Idx)
     C                   MOVEL     'USR8978'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      * First 6 characters must be all alpha
     C     WKC6NL        IFEQ      '1'
     C**********         MOVE      'N'           DDCSI2OK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCSI2'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR8979'     MsgIdXAr(Idx)                              AR855391
     C                   MOVE      'W'           DDCSI2OK                                   AR855391
     C                   ADD       1             WIx                                        AR855391
     C                   MOVEL     'DDCSI2'      WFldNmXAr(WIx)                             AR855391
     C                   MOVEL     'USR8979'     WMsgIDXAr(WIx)                             AR855391
     C                   END
      * No invalid characters may be entered
     C     WKINVC        IFEQ      '1'
     C**********         MOVE      'N'           DDCSI2OK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCSI2'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR8980'     MsgIdXAr(Idx)                              AR855391
     C                   MOVE      'W'           DDCSI2OK                                   AR855391
     C                   ADD       1             WIx                                        AR855391
     C                   MOVEL     'DDCSI2'      WFldNmXAr(WIx)                             AR855391
     C                   MOVEL     'USR8980'     WMsgIDXAr(WIx)                             AR855391
     C                   END
      * ID may have no embedded spaces
     C     WKEMSP        IFEQ      '1'
     C**********         MOVE      'N'           DDCSI2OK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCSI2'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR8981'     MsgIdXAr(Idx)                              AR855391
     C                   MOVE      'W'           DDCSI2OK                                   AR855391
     C                   ADD       1             WIx                                        AR855391
     C                   MOVEL     'DDCSI2'      WFldNmXAr(WIx)                             AR855391
     C                   MOVEL     'USR8981'     WMsgIDXAr(WIx)                             AR855391
     C                   END
      * ID must be 8 or 11 characters in length
     C     WKSICL        IFEQ      '1'
     C     WKSIL8        OREQ      '1'
     C     WKBICL        OREQ      '1'
     C                   MOVE      'N'           DDCSI2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSI2'      FldNamXAr(Idx)
     C                   MOVEL     'USR8982'     MsgIdXAr(Idx)
     C                   END
 
 
      * Otherwise (i.e. module MIDAS/SWIFT direct link is OFF)
     C                   ELSE
 
      * SWIFT ID must be blank
     C                   MOVE      'N'           DDCSI2OK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSI2'      FldNamXAr(Idx)
     C                   MOVEL     'USR8983'     MsgIdXAr(Idx)
     C                   END
 
     C                   MOVEL     DDCSI2        WKCSI28
     C                   MOVE      DDCSI2        WKCSI24           4
     C                   MOVEL     WKCSI24       WKCSI23
 
      * Call program to validate ID
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       WKBICR            7
     C                   PARM                    WKCSI28           8
     C                   PARM                    WKCSI23           3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       WKBICC            1
     C                   PARM      *BLANKS       WKBICS            1
     C                   PARM      *BLANKS       WKBICI            1
 
      * BIC identifier not found
     C     WKBICR        IFEQ      'MIN0244'
     C     WKBICR        OREQ      'MIN0245'
     C     WKBICR        OREQ      'MIN0246'
     C**********         MOVE      'N'           DDCSI2OK                                   AR855391
     C**********         ADD       1             Idx                                        AR855391
     C**********         MOVEL     'DDCSI2'      FldNamXAr(Idx)                             AR855391
     C**********         MOVEL     'USR8984'     MsgIdXAr(Idx)                              AR855391
     C                   MOVE      'W'           DDCSI2OK                                   AR855391
     C                   ADD       1             WIx                                        AR855391
     C                   MOVEL     'DDCSI2'      WFldNmXAr(WIx)                             AR855391
     C                   MOVEL     'USR8984'     WMsgIDXAr(WIx)                             AR855391
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
      ** Customer SWIFT ID (12A) - original
     C                   PARM                    DDCSID           12
     C                   PARM                    DDCSIDOK          1
      *
      ** Customer SWIFT ID 2 (12A)
      ** MIDAS/SWIFT direct link (1A)
     C                   PARM                    DDCSI2           12
     C                   PARM                    BGMSDL            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                  AR855391
     C                   PARM                    WMsgIDXAr                                  AR855391
     C                   PARM                    WMsgDtXAr                                  AR855391
      *
      ** SWIFT ID - OK
     C                   PARM                    DDCSI2OK          1
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
