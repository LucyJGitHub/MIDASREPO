     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans Log Setup Module')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LECLIPLOG - LE Customer Loans Log Setup Module               *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             LE Customer loans Details file into screen        *
      *             format to be used in writing records to the log   *
      *             file.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CDL094             Date 01Sep14               *
      *  Prev Amend No. MD025521           Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10574           Date 02Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 10Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CDL018             Date 03Feb04               *
      *                 225959             Date 23Mar04               *
      *                 CAP074  *CREATE    Date 14May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245273 - Recompiled due to changes in LECLI1PD.              *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  225959 - Missing CAS00x changes                              *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D TRANFilFmtCL  E DS                  EXTNAME(CLOANCL)
     D  CLoanREC             459    527
     D  CLoanPAY             528   1086
     D TRANFilFmtCK  E DS                  EXTNAME(CLOANCK)
      ***  Midas LE API CLIP File Record
     D                                     PREFIX(K_)
      *
     D LoanScnFmt1   E DS                  EXTNAME(LECLI1PD)
      ***  Midas LE API CLIP Format Definition File Screen 1
      *
     D LoanScnFmt2   E DS                  EXTNAME(LECLI2PD)
      ***  Midas LE API CLIP Format Definition File Screen 2
      *
     D LoanScnFmt3   E DS                  EXTNAME(LECLI3PD)
      ***  Midas LE API CLIP Format Definition File Screen 3
      *
     D LoanScnFmt4   E DS                  EXTNAME(LECLI4PD)
      ***  Midas LE API CLIP Format Definition File Screen 4
      *
     D F_REC         E DS                  EXTNAME(SDESFRPD)
      ***  File Receive instructions
     D  FLREC                  1     69
      *
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
      ***  File Payment instructions
     D  FLPAY                  1    559
 
     D FRIRFilFmt    E DS                  EXTNAME(SDESFFPD)
      ** Midas SD File Extended Settlement Instruction - FRA/IRS
 
     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)
      ** Midas SD Screen Extended Settlement Instruction - Pay
 
     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)
      ** Midas SD Screen Extended Settlement Instruction - Receive
 
     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)
      ** Midas SD Screen Extended Settlement Instruction - FRA/IRS
 
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access Programs, Short Data Structure
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
     D PACTN           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSTS            S             24A
     D PCSTS           S             10A
     D TRANSDTL        S           5800A
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ***  Convert file fields into screen format
      *
     C                   EXSR      SRPROC
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPROC - Convert file fields into screen format              *
      *****************************************************************
     C     SRPROC        BEGSR
      *
     C                   EVAL      TRANSDTL = *BLANKS
     C
     C                   EVAL      DDACTN = PACTN
      *
      ***  Process Settlement Instructions part
      *
     C                   EXSR      SRSETD
      *
      ***  Process convert file to screen 1
      *
     C                   CALLB     'LECLIP1CT'
      *
      ***  INPUTS parameters
      *
      ***  Return Code
     C                   PARM                    RetCodeOut
      *
      ***  Loan in file format CL
     C                   PARM                    TRANFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    TRANFilFmtCK
      *
      ***  OUTPUTS parameters
      *
     C                   PARM                    LoanScnFmt1
      *
      ***  Process convert file to screen 2
      *
     C                   CALLB     'LECLIP2CT'
      *
      ***  INPUTS parameters
      *
      ***  Return Code
     C                   PARM                    RetCodeOut
      *
      ***  Loan in file format CL
     C                   PARM                    TRANFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    TRANFilFmtCK
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
      *
      ***  OUTPUTS parameters
      *
     C                   PARM                    LoanScnFmt2
      *
      ***  Process convert file to screen 3
      *
     C                   CALLB     'LECLIP3CT'
      *
      ***  INPUTS parameters
      *
      ***  Return Code
     C                   PARM                    RetCodeOut
      *
      ***  Loan in file format CL
     C                   PARM                    TRANFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    TRANFilFmtCK
      *
      ***  OUTPUTS parameters
      *
     C                   PARM                    LoanScnFmt3
      *
      ***  Process convert file to screen 4
      *
     C                   CALLB     'LECLIP4CT'
      *
      ***  INPUTS parameters
      *
      ***  Return Code
     C                   PARM                    RetCodeOut
      *
      ***  Loan in file format CL
     C                   PARM                    TRANFilFmtCL
      *
      ***  Loan in file format CK
     C                   PARM                    TRANFilFmtCK
      *
      ***  OUTPUTS parameters
      *
     C                   PARM                    LoanScnFmt4
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
      *
     C                   ELSE
      *
 
     C                   CALLB     'ZASETINCVT'
 
     C                   PARM                    F_PAY
     C                   PARM                    F_REC
     C                   PARM      *BLANKS       FRIRFilFmt
     C                   PARM      *BLANKS       PAYScnFmt
     C                   PARM      *BLANKS       RECScnFmt
     C                   PARM      *BLANKS       FRIRScnFmt
     C                   PARM      DDCURR        #TRCCY                                      CSF011A
     C                   PARM      DDCURR        #TPCCY                                      CSF011A
 
      *
     C                   EVAL      TRANSDTL = LoanScnFmt1+ LoanScnFmt2+
     C                                        LoanScnFmt3+ LoanScnFmt4+
     C                                        RECScnFmt + PAYScnFmt
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRSETD - Set Settlement Instructions Input                   *
      *****************************************************************
     C     SRSETD        BEGSR
      *
      ***  Receipt part
      *
     C                   MOVEL     CLoanREC      F_REC
     C                   MOVE      OSDB          FLROBR
     C                   MOVE      SCCY          FLRSCY
      *
      ***  Pay part
      *
     C                   MOVEL     CLoanPAY      F_PAY
     C                   MOVE      CVMR          FLCVMR
     C                   MOVE      OMDB          FLPOBR
     C                   MOVE      SCCY          FLPSCY
     C                   MOVE      ICCY          FLIC72
      *                                                                                       CLE031
      ** If CLE031 is switched on, move file values of new fields to                          CLE031
      ** to settlement screen.                                                                CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     REXR          FLREXR                                       CLE031
     C                   Z-ADD     PEXR          FLPEXR                                       CLE031
     C                   MOVE      REXI          FLREXI                                       CLE031
     C                   MOVE      PEXI          FLPEXI                                       CLE031
     C                   MOVE      SCCY          FLRSCY                                       CLE031
     C                   MOVE      PSCY          FLPSCY                                       CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT
      ***  =====
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  Action Code
     C                   PARM                    PACTN
      *
      ***  Valid file Customer loans input CL
     C                   PARM                    TRANFilFmtCL
      *
      ***  Valid file Customer loans input CK
     C                   PARM                    TRANFilFmtCK
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
                                                                                             BUG3721
      ***  OUTPUT
      ***  ======
      *
      ***  Data Replication Details Screen Format
     C                   PARM                    TRANSDTL
      *
      ***  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database Error
      *
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD             6                          CLE031
                                                                                              CLE031
     C     PRTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C     PRTCD         IFEQ      '*NRF'                                                     CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
      ** Database error                                                                       CLE031
                                                                                              CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************* CLE031
     C                   MOVEL     '008'         DBASE                          * DBERR 008 * CLE031
     C                   MOVEL     POPTN         DBKEY                          ************* CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
