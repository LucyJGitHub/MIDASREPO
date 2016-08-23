     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency of Risk Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFVCYRK01 - Country of Risk Validation                       *
      *                                                               *
      *  Function:  This module validates country of risk.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3644            Date 12Jul04               *
      *                 TDA037             Date 25Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  TDA037 - Fix will ensure that Currency of Risk will default  *
      *           correctly.                                          *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Record not found in INTYP                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FINTYP     IF   E           K DISK
 
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** Midas Country Codes File Data Structure
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Midas Currency File Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** First DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D SCRIK           S              2A
     D SCCYR           S              3A
     D SISTT           S              5A
     D SISPT           S              1A                                                      TDA037
     D SDCCY           S              3A                                                      TDA037
 
     D PRtCd           S              7A
     D POptn           S              7A
 
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
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     C/COPY ZACPYSRC,FVAL_RESET
 
     C                   IF        SCCYR = *Blanks
     C*****SISTT         CHAIN     INTYP                              01                      TDA037
      **********                                                                              TDA037
      ***Default*value*from*INTYP*file*********************************                       TDA037
      **********                                                                              TDA037
     C**********         IF        *IN01 = '0'                                                TDA037
     C**********         IF        ISPT = 2                                                   TDA037
     C**********                   OR  ISPT = 5                                               TDA037
     C**********         EVAL      SCCYR = OTHC                                               TDA037
     C                   IF        SISPT = '2'                                                TDA037
     C                             OR  SISPT = '5'                                            TDA037
     C                   EVAL      SCCYR = SDCCY                                              TDA037
     C                   ELSE
 
      ** Access Country Codes File
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY  '      POptn
     C                   PARM                    SCRIK
     C     SDCTRY        PARM      SDCTRY        DSSDY
 
     C                   IF        PRtCd = *Blanks
     C                   EVAL      SCCYR = A4CTAY
     C                   ELSE
 
      ** A valid currency must be entered
 
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCCYR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0838'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
     C                   ENDIF
 
     C**********         ELSE                                                                 TDA037
      **********                                                                              TDA037
      ***A*valid currency must be entered                                                     TDA037
      **********                                                                              TDA037
     C**********         EVAL      XIdx = XIdx + 1                                            TDA037
     C**********         EVAL      FldNamXArr(XIdx) = 'SCCYR'                                 TDA037
     C**********         EVAL      MsgIDXArr(XIdx) = 'MMA0838'                                TDA037
     C**********         EVAL      ReturnCode = 'Error'                                       TDA037
     C**********         ENDIF                                                                TDA037
     C                   ENDIF
 
     C                   IF        ReturnCode = *Blanks
 
      ** Access Currency File
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY  '      POptn
     C                   PARM                    SCCYR
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** A valid currency must be entered
 
     C                   IF        PRtCd <> *Blanks
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCCYR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0838'
     C                   EVAL      ReturnCode = 'Error'
     C                   ELSE
     C                   EVAL      SCCYR = A6CYCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RETURN
 
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
     C                   PARM                    ReturnCode
     C                   PARM                    SCCYR
     C                   PARM                    SCRIK
     C                   PARM                    SISTT
     C                   PARM                    SISPT                                        TDA037
     C                   PARM                    SDCCY                                        TDA037
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
