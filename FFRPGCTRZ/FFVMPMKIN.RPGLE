     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate market instrument')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVMKTINS - Midas FF Validate Market Centre                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 03May06               *
      *                 CAP183  *Create    Date 05Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CAP183 - Conversion of Market Prices Input into modular      *
      *           structure to use APIs.                              *
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     DINTY           E DS                  EXTNAME(INTYPD)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D@DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *
      ** Market Instrument
      *
     DDDISTC           S              3A
      *
      ** Market Instrument returned by PGM/FF0150
      *
     D@PISTC           S                   LIKE(DDISTC)
      *
      ** Market/Instrument combination field
      *
     DKMKTINST         S              5A
      *
      ** Market/Instrument combination sent to AO/AOFFITR0
      *
     D@ISTT            S                   LIKE(KMKTINST)
      *
      ** Market
      *
     DSMRKT            S              2A
 
      ** OTC Flag
     DPOTCFlag         S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
     C     DDISTC        IFEQ      '?'
     C                   CALL      'FF0151'
     C                   PARM                    SMRKT
     C                   PARM      *BLANKS       @PISTC
     C                   PARM                    @PRTCD            4
      *
     C     @PISTC        IFNE      *BLANKS
     C                   MOVE      @PISTC        DDISTC
     C                   ENDIF
      *
     C                   ENDIF
      **                 (End of "If SISTS = '?'")
 
      *
      ** Access the market instruments file even if a question mark was
      ** entered, in order to return the complete record.
      *
     C                   MOVEL     SMRKT         KMKTINST
     C                   MOVE      DDISTC        KMKTINST
      *
     C                   CALL      'AOFFITR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      KMKTINST      @ISTT
     C     INTY          PARM      INTY          @DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
 
      ** Instrument type does not exist.
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDISTC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2106'
      *
     C                   ELSE
      *
     C     ISTI          IFEQ      'Y'
     C     POTCFlag      ANDNE     'Y'
      ** Instrument Indicator must not be 'Y' (must be 'N').
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDISTC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2107'
      *
     C                   ENDIF
      *
     C     ISTI          IFEQ      'N'
     C     POTCFlag      ANDNE     'N'
      ** Instrument Indicator must not be 'N' if inserting on OTC
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDISTC'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA2107'
 
     C                   ENDIF
 
     C                   ENDIF
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
      *
     C     *ENTRY        PLIST
      ** Outputs from this procedure
      ** ---------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** The instrument types format (data strucure)
     C                   PARM                    INTY
 
      ** Inputs to this procedure
      ** ------------------------
      ** Instrument type (3A, from transaction
     C                   PARM                    DDISTC
      ** Market I.D. (2A, from transaction)
     C                   PARM                    SMRKT
      ** Flag for OTCs
     C                   PARM                    POTCFlag
 
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
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
