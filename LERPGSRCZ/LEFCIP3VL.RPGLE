     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility LUX validation')
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEFCIP3VL - LE Facility LUX validation                       *
      *                                                               *
      *  Function: This function will do the validation of  LUX       *
      *            new screen fields.                                 *
      *                                                               *
      *  Called By: LEFCIPVU - LE Facility details validate and       *
      *                        update.                                *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 09May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      /EJECT
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above
      ** fields as #ProcPgm, #ProcMod and #ProcName.  They are based on
      ** the corresponding fields in the PSDS /COPY member, so that
      ** member must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D NwFCLXScnFmt  E Ds                  EXTNAME(LEFCRXPD)
      *
      ** External DS for LE Facilities input extra data layout
      *
     D OKFlags       E Ds                  EXTNAME(LEEFCLX1PD)
      *
      ** External DS for LE Facilities Lux Error Definition
      *
     D NwFCLXFilFmt  E Ds                  EXTNAME(LEVFCLX1PD)
      *
      ** External DS for LE Facilities Lux Error Definition
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **   Customer Details
      *
     D DSSDY         E DS
      *
      **  Short Data Structure for Access Programs
      *
     D DATALUX         DS          1024
      *
      **  Data  Structure for LUX Data
      *
     D  #1CNUM                 1      6
     D  #1FACT                 7      9
     D  #1FCNO                10     11
     D  #1RCTP                12     12
     D  #1CCY                 13     15
     D  #1AMNT                16     30S 0
      *
      ** Data passed from caller program
      *
     D PACTN           S              1A
     D PIdx            S              3P 0
     D PWIdx           S              3P 0
     D PReturnCode     S             10A
     D PWarnGlobal     S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PCNUM           S             10A
     D PKYST           S              7A
 
      *****************************************************************
      *  Main Processing                                              *
      *  Calls: SRINIT                                                *
      *****************************************************************
     C                   EXSR      SRINIT
      *
      ** Validate degree of risk
      *
     C                   IF        LDGRI     <> *Blank
     C                   IF        LDGRI      < '0' Or LDGRI > '4'
     C                   EVAL      PIdx            = PIdx+ 1
     C                   EVAL      MsgIdArr(PIdx)  = 'ER32017'
     C                   EVAL      FldNameArr(PIdx)= 'LDGRI'
     C                   EVAL      PReturnCode     = 'Error'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      LDGRI      = '0'
     C                   ENDIF
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DGRIOK
     C                   PARM                    PReturnCode
     C                   PARM                    PWarnGlobal
     C                   EVAL      PReturnCode    = *Blank
      *
      ** Validate subordinate
      *
     C                   IF        LSUBR      = *Blank
     C                   EVAL      LSUBR      = 'N'
     C                   ELSE
     C                   IF        LSUBR     <> 'Y' AND LSUBR <> 'N'
     C                   EVAL      PIdx            = PIdx + 1
     C                   EVAL      MsgIdArr(PIdx)  = 'ERM2602'
     C                   EVAL      FldNameArr(PIdx)= 'LSUBR'
     C                   EVAL      PReturnCode     = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SUBROK
     C                   PARM                    PReturnCode
     C                   PARM                    PWarnGlobal
     C                   EVAL      PReturnCode    = *Blank
      *
      ** Validate mobilisable customer
      *
     C                   IF        LMOBL     <> *Blank
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      LMOBL         PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRTCD     <> *Blank
     C                   EVAL      PIdx            = PIdx + 1
     C                   EVAL      MsgIdArr(PIdx)  = 'ER32001'
     C                   EVAL      FldNameArr(PIdx)= 'LMOBL'
     C                   EVAL      PReturnCode     = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    MOBLOK
     C                   PARM                    PReturnCode
     C                   PARM                    PWarnGlobal
     C                   EVAL      PReturnCode    = *Blank
      *
     C                   IF        PIdx       = *Zero
     C                   MOVE      #1CNUM        LVCNUM
     C                   MOVE      #1FACT        LVFACT
     C                   MOVE      #1FCNO        LVFCNO
     C                   MOVE      LDGRI         LVDGRI
     C                   EVAL      LVSUBR     = LSUBR
     C                   EVAL      LVMOBL     = BBCUST
     C                   EVAL      LVEXPO     = *ZERO
     C                   ENDIF
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRINIT - Initial Processing                                  *
      *  Called by: Main Routine                                      *
      *  Calls: None                                                  *
      *****************************************************************
     C     SRINIT        BEGSR
     C                   EVAL      PIdx       = *Zero
     C                   EVAL      PReturnCode= *Blank
     C                   EVAL      DGRIOK     = 'Y'
     C                   EVAL      SUBROK     = 'Y'
     C                   EVAL      MOBLOK     = 'Y'
     C                   RESET                   NwFCLXFilFmt
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Initialization Subroutine                           *
      *****************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        Plist
     C                   PARM                    PACTN
     C                   PARM                    DATALUX
     C                   PARM                    NwFCLXScnFmt
     C                   PARM                    OKFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    PIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    PWIdx
     C                   PARM                    NwFCLXFilFmt
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEFCIP3VL'   DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      *****************************************************************
