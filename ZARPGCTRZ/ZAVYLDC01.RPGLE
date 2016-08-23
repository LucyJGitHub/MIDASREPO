     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Validate Default Yield Curves')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZAVYLDC01 - Midas ZS Validate Default Yield Curves           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL038             Date 10May05               *
      *                 BUG11040           Date 28Mar06               *
      *                 CAS008             Date 16Jun04               *
      *                 CAS005             Date 16Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG11040 - Improve error handling                            *
      *  CAS008 - IAS39 Enhancements                                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Find indicator in chain to file FDDTSTPD        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValid - Validate Yield Curve                                *
      * *PSSR   - Error processing                                    *
      * *INZSR  - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Yield Curves file
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
 
      ** External data structure for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PDTYP           S              2A
     D PSTYP           S              2A
     D PCLAS           S              4A                                                      CDL038
     D PYLDC           S              5A
     D PYCOK           S              1A
     D PFVYC           S              5A
     D PYCFN           S              6A
     D PERTP           S              1A
     D PFwRv           S              1A                                                      CAS005
     D PFwYC           S              5A                                                      CAS005
     D PFCRv           S              1A                                                      CAS008
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
                                                                                            BUG11040
      ** Reset return variables                                                             BUG11040
     C                   Clear                   RetCodeIn                                  BUG11040
     C                   Eval      PERTP = '0'                                              BUG11040
 
      ** Yield Curve Validation
 
     C                   EXSR      SRValid
 
      ** If an error was found, set the return code appropriately
 
     C     PYCOK         IFEQ      'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValid - Validate Yield Curve                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: AOYLDCR0                                               *
      *                                                               *
      *****************************************************************
 
     C     SRValid       BEGSR
 
      ** Initialize file field.
 
     C                   MOVE      *BLANKS       PFVYC
 
      ** Entry is not blank
 
     C                   IF        PYLDC <> *BLANKS
 
      ** Check if entry is a valid Yield Curve name
 
     C                   CALLB     'AOYLDCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
 
     C                   IF        (PRTCD <> *BLANKS) AND (PRTCD <> '*NOSEL')
     C                   EVAL      PYCOK = 'N'
     C                   EVAL      PERTP = '1'
     C                   GOTO      ESRValid
     C                   ENDIF
 
      ** No error, pass back the selected/retrieved yield curve details
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PFVYC = FSYLDC
     C                   EVAL      PYLDC = FSYLDC
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PYLDC = *BLANK
 
      ** If entry is blank, check defaults from deal type/subtype table
 
     C     KDTST         CHAIN     FDDTSTL1                           01
 
                                                                                            BUG11040
      ** Deal type/subtype record not found                                                 BUG11040
     C                   If        *IN01 = *On                                              BUG11040
     C                   Eval      PERTP = '1'                                              BUG11040
     C                   Eval      PYCOK = 'N'                                              BUG11040
     C                   GoTo      ESRValid                                                 BUG11040
     C                   EndIf                                                              BUG11040
 
      ** Deal type/subtype record found
 
     C                   IF        *IN01 = *OFF
                                                                                              CAS005
      ** Check Revaluation/Forward Flag                                                       CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
                                                                                              CAS005
      ** When yield curve passed is a Forward Yield Curve                                     CAS005
     C                   WHEN      PFwRv = 'F'                                                CAS005
                                                                                              CAS005
      ** Error if Fwd Yield Curve Mandatory = 'Y' & default value from file is                CAS005
      ** blanks                                                                               CAS005
                                                                                              CAS005
     C                   IF        FSFYCM  = 'Y' AND                                          CAS005
     C                             ((PYCFN = 'DDOFYC' AND FSORFY = *BLANKS) OR                CAS005
     C                             (PYCFN <> 'DDOFYC' AND FSTHFY = *BLANKS))                  CAS005
     C                   EVAL      PYCOK = 'N'                                                CAS005
     C                   EVAL      PERTP = '2'                                                CAS005
     C                   GOTO      ESRValid                                                   CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Else, default value from file.                                                       CAS005
                                                                                              CAS005
     C                   IF        PYCFN = 'DDOFYC'                                           CAS005
     C                   EVAL      PFVYC = FSORFY                                             CAS005
     C                   EVAL      PYLDC = FSORFY                                             CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      PFVYC = FSTHFY                                             CAS005
     C                   EVAL      PYLDC = FSTHFY                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** When yield curve passed is a Forward Commitment                                      CAS008
     C                   WHEN      PFCRv = 'C'                                                CAS008
                                                                                              CAS008
      ** Error if Fwd Commitment Yield Curve Mandatory = 'Y' & default value from file is     CAS008
      ** blanks                                                                               CAS008
                                                                                              CAS008
     C                   IF        FSFCCM  = 'Y' AND                                          CAS008
     C                             ((PYCFN = 'DDOFCC' AND FSOFCY = *BLANKS) OR                CAS008
     C                             (PYCFN <> 'DDOFCC' AND FSTFCY = *BLANKS))                  CAS008
     C                   EVAL      PYCOK = 'N'                                                CAS008
     C                   EVAL      PERTP = '2'                                                CAS008
     C                   GOTO      ESRValid                                                   CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Else, default value from file.                                                       CAS008
                                                                                              CAS008
     C                   IF        PYCFN = 'DDOFCC'                                           CAS008
     C                   EVAL      PFVYC = FSOFCY                                             CAS008
     C                   EVAL      PYLDC = FSOFCY                                             CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      PFVYC = FSTFCY                                             CAS008
     C                   EVAL      PYLDC = FSTFCY                                             CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** When yield curve passed is a Revaluation Yield Curve                                 CAS005
     C                   WHEN      PFWRV <> 'F'                                               CAS005
 
      ** Error if Yield Curve Mandatory = 'Y' and default value from file is blank
 
     C                   IF        FSYLDM  = 'Y' AND
     C                             ((PYCFN = 'DDOYLC' AND FSOURY = *BLANKS) OR
     C                             (PYCFN <> 'DDOYLC' AND FSTHRY = *BLANKS))
     C                   EVAL      PYCOK = 'N'
     C                   EVAL      PERTP = '2'
     C                   GOTO      ESRValid
     C                   ENDIF
 
      ** Else, default value from file.
 
     C                   IF        PYCFN = 'DDOYLC'
     C                   EVAL      PFVYC = FSOURY
     C                   EVAL      PYLDC = FSOURY
     C                   ELSE
     C                   EVAL      PFVYC = FSTHRY
     C                   EVAL      PYLDC = FSTHRY
     C                   ENDIF
                                                                                              CAS005
      ** If Forward Yield Curve is entered, Revaluation yield curve must be                   CAS005
      ** populated                                                                            CAS005
                                                                                              CAS005
     C                   IF        PFwYC <> *BLANKS AND PYLDC = *BLANKS                       CAS005
     C                   EVAL      PYCOK = 'N'                                                CAS005
     C                   EVAL      PERTP = '4'                                                CAS005
     C                   GOTO      ESRValid                                                   CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESRVAlid      ENDSR
 
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
 
     C     *entry        PLIST
 
      ** INPUTS
      ** ------
 
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Deal Screen fields
     C                   PARM                    PDTYP
     C                   PARM                    PSTYP
     C                   PARM                    PCLAS                                        CDL038
     C                   PARM                    PYLDC
      ** Field name
     C                   PARM                    PYCFN
      ** Forward/Revaluation Flag                                                             CAS005
     C                   PARM                    PFwRv                                        CAS005
      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
     C                   PARM                    PFwYC                                        CAS005
      ** Forward/Revaluation Commitment Flag                                                  CAS008
     C                   PARM                    PFCRv                                        CAS008
 
      ** OUTPUTS
      ** -------
 
      ** Yield Curve - OK
     C                   PARM                    PYCOK
      ** Error Type
     C                   PARM                    PERTP
      ** Yield Curve
     C                   PARM                    PFVYC
 
      ** Deal Type / subtype key fields
 
     C     KDTST         KLIST
     C                   KFLD                    PDTYP
     C                   KFLD                    PSTYP
     C                   KFLD                    PCLAS                                        CDL038
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
