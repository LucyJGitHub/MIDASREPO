     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX CLS Pay-in Schedule Maintenance Display')
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange (Dealing) Module                    *
      *                                                               *
      *  FXCLSPDSP - CLS Pay-in Schedule Maintenance (Display)        *
      *                                                               *
      *  Function:  This API module will serve as the screen display/ *
      *             input module of CLS Pay-in Schedule maintenance   *
      *             program and will be made switchable under enhance *
      *             ment number CDL008.                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG5671            Date 31Jan05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 02Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 187730             Date 15Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187252             Date 04Dec00               *
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG5671- Add Sequence number to detail record (recompile)    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *  187730 - Allow enquiry of deleted CLS pay-in schedules       *
      *  187252 - F6 to authorise CLS pay-in schedules                *
      *  CDL008 - Continuous Linked Settlement.                       *
      *                                                               *
      *****************************************************************
      *
     FFXCLSPDDF CF   E             WORKSTN SFILE(FXCLSPS0:SRLRN)
     FFXCLSPSDL0IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       25  Protect header fields                               *
      *       26  Protect Total Amount receive field                  *
      *       27  Protect Pay-in detail fields                        *
      *       30  Rollup/Rolldown not displayed for initial screen    *
      *       32  F10 not enabled and not displayed                   *
      *       35  Receive details displayed, off if Pay-in details    *
      *       40  Subfile next change                                 *
      *       41  Subfile clear                                       *
      *       42  Subfile display                                     *
      *       43  Subfile end                                         *
      *       45  Rollup pressed                                      *
      *       51  End of file or record not found for file FXCLSPSD   *
      *     60-69 Field Error - highlight screen fields               *
      *       81  Status field is displayed                           *                       187730
      *       82  F6 not enabled and not displayed                    *                       187252
      *       85  F7 not enabled and not displayed                    *                       CAP084
      *       86  F8 not enabled and not displayed                    *                       CAP084
      *       90  End of subfile for READC                            *
      *       99  End of subfile for CHAIN                            *
      *                                                               *
      ********************************************************************
      /EJECT
      *****************************************************************
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
                                                                                              187730
     D C_Dlt_Bef       C                   CONST('DELETED BEFORE AUTHORISATION')              187730
     D C_Dlt_Aft       C                   CONST('DELETED AFTER AUTHORISATION')               187730
     D C_Auth          C                   CONST('         AUTHORISED         ')              187730
     D C_Complete      C                   CONST('          COMPLETE          ')              187730
                                                                                              187730
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Error indicators array and index
     D @EI             S              1    DIM(60)
 
      ** Initial screen fields data structure
     D ScrnDS1         DS
     D  SActn                  1      1
     D  SCurr                  2      4
     D  SNost                  5      6
     D  SVdat                  7     12
     D  SSeqNo                13     14
     D  SPrfc                 15     18
     D  STdCET                19     23
     D  STPAmt                24     41
     D  STRAmt                42     59
     D  SNPAmt                60     77
     D  SNRAmt                78     95
 
      ** Detail screen fields data structure
     D ScrnDS2         DS
     D  STime                  1      4
     D  SAmnt                  5     22
 
      ** CLS Pay-in Schedule Header Format
     D CurrCLSHead   E DS                  EXTNAME(FXCLSPHPD)
 
      ** CLS Pay-in Schedule Detail Format
     D CurrCLSDet    E DS                  EXTNAME(FXCLSPDPD)
     D                                     PREFIX(@)
 
      ** CLS Error Definition format for Pay-in Schedule Header
     D CLSHErr       E DS                  EXTNAME(FXECLSPHPD)
 
      ** CLS Error Definition format for Pay-in Schedule Detail
     D CLSDErr       E DS                  EXTNAME(FXECLSPDPD)
     D                                     PREFIX(@)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External DS for Deal ICD Details
 
      ** DS for Access Object Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
 
     D C               S              2  0
     D E               S              2  0
 
      ** Function Keys
     D PFuncKeys       S              2A
 
      ** Pay/Receive indicator and screen indicator
     D PPayRcv         S              1A
     D PScreenInd      S              1A
     D SflAction       S              2A
     D A6NBDP          S              1  0
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
 
      ** Initialise header and screen indicators
 
     C                   ExSr      SrInzHdr
      *
      ** Screen required is 'I' write initial screen
      *
     C     PScreenInd    CasEq     'I'           SrScrnInit
      *
      ** Screen required is 'D' write detail screen
      *
     C     PScreenInd    CasEq     'D'           SrScrnDetl
     C                   EndCs
      *
      ** Setup Return keys
      *
     C                   ExSr      SrRetKeys
      *
     C                   Return
 
      *****************************************************************
      *                                                               *
      * SR/SrScrnInit: Initial screen processing                      *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     SrScrnInit    BegSr
      *
     C                   Eval       C = 1
     C                   Eval       E = 60
     C                   MoveA     CLSHErr       @EI
      *
      ** Seton all indicators for invalid initial screen fields.
      *
     C                   DoU        C > 11
      *
     C                   If         @EI(C) = 'N'
     C                   MoveL     '1'           *IN(E)
     C                   Endif
      *
     C                   Add       1             C
     C                   Add       1             E
     C                   Enddo
      *
      ** Write error messages to subfile when error found
      *
     C                   ExSr      SrError
      *
      ** For initial screen, Rollup/Rolldown and F10 key must not be
      ** shown
      ** and F6 key must also not be shown                                                    187252
      ** and F7 and F8 keys must not be shown                                                 CAP084
      *
     C                   Eval      *IN30 = *On
     C                   Eval      *IN32 = *On
     C                   Eval      *IN82 = *On                                                187252
     C                   Eval      *IN70 = *On
     C                   Eval      *IN81 = *Off
     C                   EVAL      *IN85 = *ON                                                CAP084
     C                   EVAL      *IN86 = *ON                                                CAP084
     C                   Write     FXCLSPC1
     C                   Write     FXCLSPF0
     C                   ExFmt     FXCLSPD0
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SR/SrScrnDetl: Detail screen processing                       *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     SrScrnDetl    BegSr
      *
      ** Build Subfile
      *
     C                   Select
     C     SFLAction     WhenEq    'BS'
     C     SFLAction     OrEq      'RS'
     C     SFLAction     OrEq      'CP'
     C                   Exsr      SrDspSfl
      *
      ** Read Change in subfile
      *
     C     SFLAction     WhenEq    'RC'
     C                   Exsr      SrRdChgS
      *
      ** Update current subfile and read next change
      *
     C     SFLAction     WhenEq    'UC'
     C                   Exsr      SrUpdRcg
      *
      ** Read subfile record
      *
     C     SFLAction     WhenEq    'RD'
     C                   Exsr      SrRdSflR
      *
     C                   EndSl
      *
     C                   Endsr
      *****************************************************************
      *                                                               *
      * SR/SrDspSfl: Display Subfile processing                       *
      *                                                               *
      * Called By: SrScrnDetl subroutine                              *
      *                                                               *
      * Calls: SrError - Error processing                             *
      *        SrSflDtl- Protect/Unprotect subfile for Pay screen     *
      *        SrBldSfl- Initial subfile build processing             *
      *        SrBldPag- Build a page of subfile                      *
      *        SrRdsSfl- Redisplay subfile                            *
      *                                                               *
      *****************************************************************
      *
     C     SrDspSfl      BegSr
      *
      ** Display initial screen (protected)
      *
     C                   Eval      *IN25 = *On
      *
     C                   Eval       C = 7
     C                   Eval       E = 68
     C                   MoveA     CLSDErr       @EI
      *
      ** Seton all indicators for invalid detail screen fields.
      *
     C                   DoU        C > 10
      *
     C                   If         @EI(C) = 'N'
     C                   MoveL     '1'           *IN(E)
     C                   Endif
      *
     C                   Add       1             C
     C                   Add       1             E
     C                   Enddo
      *
      ** Seton error indicator for total receive if not valid
      *
     C                   If        CLSTOROK = 'N'
     C                   Eval      *IN67 = *ON
     C                   Endif
      *
      ** Write error messages to subfile when error found
      *
     C                   ExSr      SrError
      *
      ** For detail screen, Rollup/Rolldown must be shown
      *
     C                   Eval      *IN30 = *Off
      *
      ** If Action is delete, Function key F10 must be shown
      *
     C                   If        CLSACT = 'D'
     C                   Eval      *IN32 = *Off
     C                   Endif
      *                                                                                       187252
      ** If Action is authorise, Function key F6 must be shown                                187252
      *                                                                                       187252
     C                   If        CLSACT = 'X'                                               187252
     C                   Eval      *IN82 = *Off                                               187252
     C                   Endif                                                                187252
                                                                                              CAP084
      ** If Action is Enquire, Function keys F7 and F8 must be shown                          CAP084
                                                                                              CAP084
     C                   IF        CLSACT <> 'I' AND CLSACT <> 'A' AND                        CAP084
     C                             CLSACT <> 'D' AND CLSACT <> 'X'                            CAP084
     C                   EVAL      *IN85 = *OFF                                               CAP084
     C                   EVAL      *IN86 = *OFF                                               CAP084
     C                   ENDIF                                                                CAP084
      *
      ** If Action is insert, Function key F11 must be shown
      ** but status must be hidden.
      *
     C                   If        CLSACT = 'I'
     C                   Eval      *IN70 = *Off
     C                   Eval      *IN81 = *Off
     C                   Else
     C                   Eval      *IN70 = *On
     C                   Eval      *IN81 = *On
     C                   Endif
      *
      ** Protect screen fields when 'Pay' side
      *
     C                   If        (PPayRcv = 'P')
     C                   Move      *On           *IN26
     C                   Move      *Off          *IN27
     C                   Move      *Off          *IN35
     C                   EndIf
      *
      ** Protect screen fields when 'Receive' side
      *
     C                   If        (PPayRcv = 'R')
     C                   Move      *On           *IN27
     C                   Move      *Off          *IN26
     C                   Move      *On           *IN35
     C                   EndIf
      *
      ** Protect screen fields when action code is not insert
      *
     C                   If        WriteOnly = 'Y'
     C                   Eval      *IN25 = *On
     C                   Eval      *IN26 = *On
     C                   Eval      *IN27 = *On
     C                   EndIf
      *
     C                   If        SflAction = 'CP'
     C                   Exsr      SRSflDtl
     C                   Endif
      *
     C                   If        SflAction = 'BS'
     C                   Exsr      SrBldSfl
      *
      ** Build subfile page until request to exit has been made
      *
     C     W@Exit        DoWEq     'N'
     C                   ExSr      SrBldPag
      *
      ** Receive side, read totals screen format, otherwise read sub
      ** file
      *
     C                   Write     FXCLSPC1
     C                   Write     FXCLSPF0
     C                   Write     FXCLSPD0
     C                   Select
     C                   When      PPayRcv = 'P'
     C                   Write     FXCLSPD1
     C                   ExFmt     FXCLSPC0
      *
     C                   When      PPayRcv = 'R'
     C                   Write     FXCLSPC0
     C                   ExFmt     FXCLSPD1
     C                   EndSl
      *
      ** Rollup pressed, build subfile
      *
     C                   If        *IN45 = *On
     C                   Eval      W@Exit = 'N'
     C                   Else
      *
      ** F3, F9, F15, F10 or Enter is pressed
      *
     C                   Eval      W@Exit = 'Y'
     C                   EndIf
      *
     C                   EndDo
     C                   Else
     C                   Exsr      SrRdsSfl
     C                   Endif
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SR/SrUpdRcg: Update curr slf rec and read next change         *
      *                                                               *
      * Called By: SrScrnDetl subroutine                              *
      *                                                               *
      * Calls:                                                        *
      * SrRdChgS - Read change in subfile                             *
      *                                                               *
      *****************************************************************
      *
     C     SrUpdRcg      BegSr
      *
      ** Check If detail screen fields are OK
      *
     C                   If        @CLSTIMOK = 'N'
     C                   Eval      *IN68 = *On
     C                   Else
     C                   Eval      *IN68 = *Off
     C                   EndIf
     C                   If        @CLSAMTOK = 'N'
     C                   Eval      *IN69 = *On
     C                   Else
     C                   Eval      *IN69 = *Off
     C                   EndIf
     C                   If        CLSTOROK = 'N'
     C                   Eval      *IN67 = *On
     C                   Else
     C                   Eval      *IN67 = *Off
     C                   EndIf
     C                   Eval      *IN40 = *On
     C                   Update    FXCLSPS0
     C                   Eval      *IN40 = *Off
      *
      ** Initialise ok flags
      *
     C                   Eval      CLSDErr = 'YYYYYYYYYYY'
 
     C                   ExSr      SrRdChgS
 
     C                   EndSr
      *****************************************************************
      *                                                               *
      * SR/SrBldSfl: Initial SFL build processing                     *
      *                                                               *
      * Called By: SrDspSfl subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * SrClrSfl -  Clear SFL build processing                        *
      * SrSetKFld-  Setup key fields                                  *
      *                                                               *
      *****************************************************************
 
     C     SrBldSfl      BegSr
      *
     C                   Exsr      SrClrSfl
      ** Setup Key fields
      *
     C                   ExSr      SrSetKFld
      *
      ** Reset CLS reference file to top of file
      *
     C     Klist1        Setll     FXCLPDD0                               51
      *
     C                   Move      'N'           W@Exit            1
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SR/SrClrSfl: Clear SFL build processing                       *
      *                                                               *
      * Called By: SrBldSfl subroutine                                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     SrClrSfl      BegSr
      *
      ** Initialise last relative record no. and WErrPtr workfields
      *
     C                   Z-Add     0             SRlrn
     C                   Z-Add     0             WLrcd             3 0
     C                   Z-Add     0             WErrPtr           4 0
     C                   Z-Add     0             WRecCount         4 0
     C                   Eval      *IN42 = *Off
      *
      ** Clear subfile
      *
     C                   Move      *On           *IN41
     C                   Write     FXCLSPC0
     C                   Move      *Off          *IN41
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SR/SrRdSSfl: Redisplay Subfile                                *
      *                                                               *
      * Called By: SrDspSfl subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * SrBldPag  - Build a page of subfile                           *
      *                                                               *
      *****************************************************************
      *
     C     SrRdSSfl      BegSr
      *
     C                   Z-Add     0             WErrPtr
      *
     C                   Eval      W@Exit = 'N'
      *
      ** Redisplay subfile until request to exit has been made
      *
     C     W@Exit        DowEq     'N'
      *
      ** Process subfile (Rollup is pressed)
      *
     C                   Write     FXCLSPC1
     C                   Write     FXCLSPF0
     C                   Write     FXCLSPD0
     C                   Select
     C                   When      PPayRcv = 'P'
     C                   If        SrLrn > 0
     C                   Eval      *IN42 = *On
     C                   Endif
     C                   Write     FXCLSPD1
     C                   ExFmt     FXCLSPC0
      *
     C                   When      PPayRcv = 'R'
     C                   Write     FXCLSPC0
     C                   ExFmt     FXCLSPD1
     C                   EndSl
     C                   Eval      W@Exit = 'N'
     C                   If        *IN45 = *On
     C                   ExSr      SrBldPag
     C                   Else
     C                   Eval      W@Exit = 'Y'
     C                   EndIf
     C                   EndDo
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SrRdSflR - Read Change in subfile starting from top record    *
      *                                                               *
      * Called By: SrScrnDetl subroutine                              *
      *                                                               *
      * Calls:                                                        *
      * SrRdChgs  - Read Change in Subfile                            *
      *                                                               *
      *****************************************************************
     C     SrRdSflr      BEGSR
      *
      ** Set subfile pointer to top of file
      *
     C                   Z-ADD     1             SRLRN
     C                   ExSr      SrRdChgS
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SrRdChgS - Read Change in Subfile                             *
      *                                                               *
      * Called By: SrScrnDetl, SrUpdRcg, SrRdSflr subroutine          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRdChgS      BEGSR
      *
      ** Read the subfile
      *
     C                   ReadC     FXCLSPS0                               90
      *
     C     *IN90         Ifeq      '1'
     C                   Move      'Y'           @SFLEOF           1
     C                   Else
     C                   Move      'N'           @SFLEOF
     C                   Endif
      *
     C                   Endsr
      *
      *****************************************************************
      *                                                               *
      * SR/SrBldPag: Build a page of subfile                          *
      *                                                               *
      * Called By: SrDspSfl and SrRdsSfl subroutine                   *
      *                                                               *
      * Calls:                                                        *
      * FMTAMT - Format Amount for Display                            *
      *                                                               *
      *****************************************************************
 
     C     SrBldPag      BegSr
      *
      ** Initialise Subfile and Array record counter
      *
     C                   Z-Add     1             WRCtr             4 0
     C                   Z-Add     WLrcd         SRlrn
      *
      ** Initialize Display indicator
      *
     C                   Eval      *IN42 = *On
      *
      ** Retrieve record
      *
     C     Klist1        ReadE     FXCLPDD0                               51
      *
      ** If Enquiry or Delete mode and no record matched, set *Off display
      ** indicator
      *
     C                   If        WriteOnly = 'Y' and *IN51 = *On  OR
     C                             PPayRcv ='R'
     C                   Eval      *IN42 = *Off
     C                   EndIf
      *
      ** Load records to subfile until the whole of subfile page is filled
      *
     C     WRCtr         DoWLe     4
     C     WriteOnly     AndEq     'N'
     C     WRCtr         OrLE      4
     C     WriteOnly     AndEq     'Y'
     C     *IN51         AndEq     *Off
      *
      ** Move blanks if no record read, else, move data from file
      *
     C                   If        *IN51 = *On
     C                   Eval      STime = *Blank
     C                   Eval      SAmnt = *Blank
     C                   Else
     C                   Eval      STime = PYLTIM
     C                   Move      PYAMT         @@AMTW
     C                   Exsr      FMTAMT
     C                   Move      @@AMTD        SAmnt
     C                   EndIf
      *
      ** Write record to subfile
      *
     C                   Add       1             WRCtr
     C                   Add       1             WRecCount
     C                   Add       1             SRlrn
     C                   Eval      *IN40 = *ON
      *
     C                   Write     FXCLSPS0
     C                   Eval      *IN40 = *Off
      *
     C                   If        *IN51 = *Off
     C     Klist1        ReadE     FXCLPDD0                               51
     C                   EndIf
     C                   EndDo
      *
      ** Enable subfile end for action 'E','X' or 'D' if End of File reached
      *
     C                   If        (WriteOnly = 'Y') And (*IN51 = *On)
     C                   Eval      *IN43 = *On
     C                   Else
     C                   Eval      *IN43 = *Off
      *
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
      *
     C                   If        *IN51 = *Off
     C     Klist1        ReadPE    FXCLPDD0                               51
     C                   EndIf
     C                   EndIf
      *
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
      *
     C                   Z-Add     SRlrn         WLrcd
      *
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrSflDtl: Protect subfile if confirmation screen, else     *
      *              unprotect: for 'Pay' side and if Action = I or A *
      *                                                               *
      * Called By: SrDspSfl subroutine                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrSflDtl      BegSr
 
     C                   If        PPayRcv = 'P' And
     C                             (CLSACT = 'I' Or CLSACT = 'A')
 
     C                   EVAL      *IN99 = *Off
 
     C     1             Do        WRecCount     WSflRec           4 0
     C     WSflRec       CHAIN     FXCLSPS0                           99
     C                   If        WriteOnly = 'Y'
     C                   EVAL      *IN27 = *On
     C                   Else
     C                   EVAL      *IN27 = *Off
     C                   EndIf
     C                   EVAL      *IN40 = *On
     C                   UPDATE    FXCLSPS0
     C                   Enddo
 
     C                   EVAL      *IN40 = *Off
     C                   Z-ADD     1             SRLRN
     C                   EndIf
 
     C                   Endsr
 
      *****************************************************************
      *                                                               *
      * SR/SrRetKeys: Return Keys and Output processing               *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     SrRetKeys     BegSr
      *
     C                   Eval      SVDAT = SVDAT1 + SVDAT2 + SVDAT3
     C                   MoveL     ScrnDS1       CurrCLSHead
     C                   Eval      @CLSACT = CLSACT
     C                   Eval      @CLSCCY = CLSCCY
     C                   Eval      @CLSNST = CLSNST
     C                   Eval      @CLSVDT = CLSVDT
     C                   Eval      @CLSSEQ = CLSSEQ
     C                   Eval      @CLSPRF = CLSPRF
     C                   Eval      @CLSAMT = SAmnt
     C                   Eval      @CLSTIM = STime
     C                   Eval      @CLSTMD = CLSTMD
      *
     C                   Select
     C                   When      *INKC = *On
     C                   Clear                   MsgIdArr
     C                   Clear                   ScrnDS1
     C                   Clear                   ScrnDS2
     C                   Eval      PFuncKeys = '03'
      *                                                                                       187252
     C                   When      *INKF = *On                                                187252
     C                   Eval      PFuncKeys = '06'                                           187252
                                                                                              CAP084
     C                   WHEN      *INKG = *ON                                                CAP084
     C                   EVAL      PFuncKeys = '07'                                           CAP084
                                                                                              CAP084
     C                   WHEN      *INKH = *ON                                                CAP084
     C                   EVAL      PFuncKeys = '08'                                           CAP084
      *
     C                   When      *INKI = *On
     C                   Eval      PFuncKeys = '09'
      *
     C                   When      *INKJ = *On
     C                   Eval      PFuncKeys = '10'
      *
     C                   When      *INKK = *On
     C                   Eval      PFuncKeys = '11'
      *
     C                   When      *INKL = *On
     C                   Eval      PFuncKeys = '12'
      *
     C                   When      *INKP = *On
     C                   Eval      PFuncKeys = '15'
     C                   EndSl
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SR/SrError: Error processing                                  *
      *                                                               *
      * Called By: SrScrnInit and SrScrnDetl subroutines              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     SrError       BegSr
      *
     C                   Z-Add     1             C
     C     C             DowLe     ArrayMax
     C     MsgIdArr(C)   AndNe     *Blank
     C                   MoveL     MsgIdArr(C)   WMsgId            7
     C                   MoveL     MsgDtaArr(C)  WMsgDta          45
     C                   If        WMsgDta = *Blanks
     C                   ExSr      SrErrId
     C                   Else
     C                   ExSr      SrErrDta
     C                   EndIf
     C                   Add       1             C
     C                   EndDo
      *
     C                   Z-Add     1             C
     C     C             DowLe     ArrayMax
     C     WMsgIdArr(C)  AndNe     *Blank
     C                   MoveL     WMsgIdArr(C)  WMsgId
     C                   MoveL     WMsgDtaArr(C) WMsgDta
     C                   If        WMsgDta = *Blanks
     C                   ExSr      SrErrId
     C                   Else
     C                   ExSr      SrErrDta
     C                   EndIf
     C                   Add       1             C
     C                   EndDo
      *
     C                   EndSr
 
      *
      *****************************************************************
      *                                                               *
      * SR/SRInzHdr: Initialisation of header and work indicators     *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      * SrSetFld   - Setup screen field for output                    *
      *                                                               *
      *****************************************************************
 
     C     SrInzHdr      BegSr
      *
      ** Format header and sub header
      *
     C                   Eval      SWsID = PsJobName
     C                   Eval      SUser = PsUser
     C                   Eval      SRuna = BJMRDT
      *
      ** Initialise Subfile control indicators and Subfile next change
      *
     C                   MoveA     '0000'        *IN(40)
      *
      ** Initialise subfile error indicators
      *
     C                   MoveA     '0000000000'  *IN(60)
      *
      ** Initialise protect indicators
      *
     C                   MoveA     '000'         *IN(25)
      *
      ** Initialise show/not show footer field indicator
      *
     C                   Eval      *IN30 = *Off
      *
      ** Clear Function Key variables
      *
     C                   Move      *Blanks       PFuncKeys
      *
      ** Write Screen Header
      *
     C                   Write     FXCLSPH0
 
      ** Setup screen and key fields
 
     C                   ExSr      SrSetFld
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SR/SrSetFld: Setup initial value of screen fields             *
      *                                                               *
      * Called By: SrInzHdr subroutine                                *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     SrSetFld      BegSr
      *
      ** Clear screen fields
      *
     C                   Eval      ScrnDS1 = *Blanks
     C                   Eval      ScrnDS2 = *Blanks
     C                   Eval      SVDAT1 = *Blanks
     C                   Eval      SVDAT2 = *Blanks
     C                   Eval      SVDAT3 = *Blanks
      *
      ** Move passed data to screen fields
      *
     C                   Eval      SActn = CLSACT
     C                   Eval      SCurr = CLSCCY
     C                   Eval      SNost = CLSNST
     C                   EVal      SVdat1 = %SubSt(CLSVDT:1:2)
     C                   EVal      SVdat2 = %SubSt(CLSVDT:3:2)
     C                   EVal      SVdat3 = %SubSt(CLSVDT:5:2)
     C                   Eval      SSeqNo = CLSSEQ
     C                   Eval      STdCET = CLSTMD
     C                   Eval      SPrfc = CLSPRF
     C                   Eval      STime = @CLSTIM
     C                   Eval      SAmnt = @CLSAMT
     C                   Eval      STPAmt = CLSTOP
     C                   Eval      STRAmt = CLSTOR
     C                   Eval      SNPAmt = CLSPYN
     C                   Eval      SNRAmt = CLSRCN
      *                                                                                       187730
      ** Status field                                                                         187730
      *                                                                                       187730
     C                   Exsr      SrSetKFld                                                  187730
     C     Klist1        Chain     FXCLPDD0                           51                      187730
      *                                                                                       187730
     C***********        If        CLSSFL = 'Y'                                               187730
     C***********        Eval      SSTAT = '*AUTHORISED*'                                     187730
     C***********        Else                                                                 187730
     C***********        Eval      SStat = '**COMPLETE**'                                     187730
     C***********        Endif                                                                187730
      *                                                                                       187730
     C                   Select                                                               187730
     C                   When      PYRECI <> 'D' AND CLSSFL <> 'Y'                            187730
     C                   Eval      SStat = C_Dlt_Bef                                          187730
     C                   When      PYRECI <> 'D' AND CLSSFL = 'Y'                             187730
     C                   Eval      SStat = C_Dlt_Aft                                          187730
     C                   When      PYRECI = 'D' AND CLSSFL = 'Y'                              187730
     C                   Eval      SStat = C_Auth                                             187730
     C                   When      PYRECI = 'D' AND CLSSFL <> 'Y'                             187730
     C                   Eval      SStat = C_Complete                                         187730
     C                   EndSL                                                                187730
      *
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrSetKFld - Setup Key fields                               *
      *                                                               *
      * Called By: SrBldSfl subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * ZDATE1  - Converts date to Midas day number.                  *
      *                                                               *
      *****************************************************************
      *
     C     SrSetKFld     BegSr
      *
      ** Move passed data to key fields
      *
     C                   Eval      WCurr = SCurr
     C                   Eval      WNost = SNost
     C                   Movel     SSeqNo        WSeqNo
      *
      ** Convert date to day number
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    CLSVDT
     C                   PARM      *Zero         WVdayNo
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * FMTAMT - Format Amount for Display                            *
      *                                                               *
      * Called By: SrBldPag subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * ZA0921 - Format amount for output base on ccy decimal places  *
      *                                                               *
      *****************************************************************
     C     FMTAMT        Begsr
      *
     C                   CallB     'ZA0921'
     C                   Parm                    RetCodeOut
     C                   Parm                    @@AMTW           15 0
     C                   Parm      A6NBDP        W@DECP            1 0
     C                   Parm      BNDCSP        @@DCSP            1
     C                   Parm      *BLANK        @@AMTP           16
     C                   Parm      *BLANK        @@AMTD           17
      *
     C                   Endsr
      *
      *****************************************************************
      *                                                               *
      * SR/SrErrDta: Output error messages with data                  *
      *                                                               *
      * Called By: SrError subroutine                                 *
      *                                                               *
      * Calls:                                                        *
      * ZA0350   - Add messages to pgm subfile message queue          *
      *                                                               *
      *****************************************************************
      *
     C     SrErrDta      BegSr
      *
     C                   Eval      WZMsgId = *Blank
     C                   Eval      WZMsgId = WMsgId
      *
     C                   Call      'ZA0350'
     C                   Parm                    WZMsgFile        10
     C                   Parm                    WZMsgId          10
     C                   Parm      WMsgDta       WZMsgData        45
      *
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SR/SrErrId: Output error message without data                 *
      *                                                               *
      * Called By: SrError subroutine                                 *
      *                                                               *
      * Calls:                                                        *
      * ZA0340   - Add messages to pgm subfile message queue          *
      *                                                               *
      *****************************************************************
      *
     C     SrErrId       BegSr
      *
     C                   Eval      WZMsgId = *Blank
     C                   Eval      WZMsgId = WMsgId
      *
     C                   Call      'ZA0340'
     C                   Parm                    WZMsgFile
     C                   Parm                    WZMsgId
      *
     C                   EndSr
      *
      *****************************************************************
      *                                                               *
      * SR/*InzSr: Initialisation Routine                             *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *InzSr        BegSr
      *
      ** Entry Parameters
      *
     C     *Entry        PList
     C                   Parm                    RetCodeOut
     C                   Parm                    PPayRcv
     C                   Parm                    PScreenInd
     C                   Parm                    CurrCLSHead
     C                   Parm                    CurrCLSDet
     C                   Parm                    CLSHErr
     C                   Parm                    CLSDErr
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIdArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    PFuncKeys
     C                   Parm                    Writeonly
     C                   Parm                    SflAction
     C                   Parm                    @SflEof
     C                   Parm                    A6NBDP
      *
      ** Keylist to access detail file FXCLSPDPD
      *
     C     KList1        Klist
     C                   Kfld                    WCurr             3
     C                   Kfld                    WNost             2
     C                   Kfld                    WVdayNo           5 0
     C                   Kfld                    WSeqNo            2 0
      *
      ** Format Program Details
      *
     C                   Eval      DbPgm = 'FXCLSPDSP'
      *
      ** Access Bank Details via Access Object AOBANKR0
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RtCd
     C                   Parm      '*FIRST '     @Optn
     C     SDBANK        Parm      SDBANK        DSFDY
      *
     C     @RtCd         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Move      *On           *INU7
     C                   Move      *On           *INU8
     C                   MoveL     'SDBANKPD'    DbFile                         ************
     C                   Z-Add     001           Dbase                          * DBERR 01 *
     C                   MoveL     @Optn         DbKey                          ************
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
      ** Access Deal ICD Details
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Initialise subfile program queue and message file
      *
     C                   MoveL     '*'           SPGMQ
     C                   MoveL     'DRSMM'       WZMsgFile
      *
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
