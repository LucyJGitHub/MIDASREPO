     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Intermediary Fields')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVINTM - Validate Intermediary Fields                       *
      *                                                               *
      *  Component of: SETSESVAL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSE045   *CREATE   Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D***@IM****         S             12    DIM(9)                                          CSW206D
     D***@IM****         S             12    DIM(2)                                  CSW206D CSW206E
     D***WIMDArr         S             12    DIM(9)                                          CSW206D
     D***WIMDArr         S             12    DIM(2)                                  CSW206D CSW206E
     D @IM             S             12    DIM(9)                                            CSW206E
     D WIMDArr         S             12    DIM(9)                                            CSW206E
      *
      ** DS for Validation of Intermediary
     D WInterMEd       DS
     D WSIMMD1                 1     12
     D WSIMMD2                13     24
     D***WSIMMD3                25     36                                                    CSW206D
     D***WSIMMD4                37     48                                                    CSW206D
     D***WSIMMD5                49     60                                                    CSW206D
     D***WSIMMD6                61     72                                                    CSW206D
     D***WSIMMD7                73     84                                                    CSW206D
     D***WSIMMD8                85     96                                                    CSW206D
     D***WSIMMD9                97    108                                                    CSW206D
     D WSIMMD3                25     36                                                      CSW206E
     D WSIMMD4                37     48                                                      CSW206E
     D WSIMMD5                49     60                                                      CSW206E
     D WSIMMD6                61     72                                                      CSW206E
     D WSIMMD7                73     84                                                      CSW206E
     D WSIMMD8                85     96                                                      CSW206E
     D WSIMMD9                97    108                                                      CSW206E
 
      *
      ** Security API Trades Extended Settlements from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      ** Security API Trades Extended Settlements for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)
      *
      ** Security API Trades Extended Settlements error indicators
     D SEETES        E DS                  EXTNAME(SEETESPD)
      *
      ** Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Counterparty Details
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      ** Second Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     D PMode           S              6A
      *
      ** Parameters for SDCUSTPD
     D PKEY1           S             10A
     D PKYST           S              7A
      *
      ** Variable used for validation
     D JFIMMD          S             12A
     D WFldNum         S              1A
     D WCLAS           S              1A
     D WERROR          S              1A
     D WFIELD          S              7A
     D WUnqeFlg        S              1A
     D WIMFlg          S              1A
     D WCtr            S              3P 0
     D WWIMMD          S             12A
 
     D PCSID8          S              8A
     D PCSID4          S              4A
     D PCSID3          S              3A
     D PBICC           S              1A
     D PBICS           S              1A
     D PBICI           S              1A
     D PBICR           S              7A
      ** Swift 2006                                                                          CSW206E
     D CSW206          S              1A                                                     CSW206E
 
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
     C                   EVAL      IDx = 0
                                                                                             CSW206E
      ** Check if SWIFT 2006 is installed                                                    CSW206E
                                                                                             CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD             7                         CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *
      ** Validate Intermediary Fields
      *
     C                   EXSR      SRValIntm
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C     ESIMMD1OK     IFEQ      'N'
     C     ESIMMD2OK     OREQ      'N'
     C*****ESIMMD3OK     OREQ      'N'                                                       CSW206D
     C*****ESIMMD4OK     OREQ      'N'                                                       CSW206D
     C*****ESIMMD5OK     OREQ      'N'                                                       CSW206D
     C*****ESIMMD6OK     OREQ      'N'                                                       CSW206D
     C*****ESIMMD7OK     OREQ      'N'                                                       CSW206D
     C*****ESIMMD8OK     OREQ      'N'                                                       CSW206D
     C*****ESIMMD9OK     OREQ      'N'                                                       CSW206D
     C     ESIMMD3OK     OREQ      'N'                                                       CSW206E
     C     ESIMMD4OK     OREQ      'N'                                                       CSW206E
     C     ESIMMD5OK     OREQ      'N'                                                       CSW206E
     C     ESIMMD6OK     OREQ      'N'                                                       CSW206E
     C     ESIMMD7OK     OREQ      'N'                                                       CSW206E
     C     ESIMMD8OK     OREQ      'N'                                                       CSW206E
     C     ESIMMD9OK     OREQ      'N'                                                       CSW206E
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESIMMD1OK <> 'N'
     C                   MOVEL     ESIMMD1       T2IMD1
     C                   ENDIF
 
     C                   IF        ESIMMD2OK <> 'N'
     C                   MOVEL     ESIMMD2       T2IMD2
     C                   ENDIF
 
     C                   IF        CSW206 = 'N'                                              CSW206E
                                                                                             CSW206E
     C**********         IF        ESIMMD3OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMMD3       T2IMD3                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD3OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMMD3       T2IMD3                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD4OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMMD4       T2IMD4                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD4OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMMD4       T2IMD4                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD5OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMMD5       T2IMD5                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD5OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMMD5       T2IMD5                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD6OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMMD6       T2IMD6                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD6OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMMD6       T2IMD6                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD7OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMMD7       T2IMD7                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD7OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMMD7       T2IMD7                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD8OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMMD8       T2IMD8                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD8OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMMD8       T2IMD8                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD9OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMMD9       T2IMD9                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD9OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMMD9       T2IMD9                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALINTM - Validation for Intermediary Fields               *
      *                                                               *
      *****************************************************************
 
     C     SRValIntm     BEGSR
 
     C                   EVAL      WERROR = 'N'
     C                   EVAL      WImFlg = 'Y'
     C                   CLEAR                   WIMDArr
      *
      ** Previous Intermediary field should not be blank
      *
     C                   IF        ESIMMD1 = *BLANKS and ESIMMD2 <> *BLANKS
     C                   EVAL      ESIMMD1OK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'SE10025'
     C                   EVAL      FldNamXAr(Idx) = 'ESIMMD1'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        CSW206 = 'N'                                              CSW206E
                                                                                             CSW206E
     C**********         IF        ESIMMD2 = *BLANKS and ESIMMD3 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      ESIMMD2OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10024'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMMD2'                                CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD2 = *BLANKS and ESIMMD3 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      ESIMMD2OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10024'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMMD2'                                CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD3 = *BLANKS and ESIMMD4 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      ESIMMD3OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10023'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMMD3'                                CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD3 = *BLANKS and ESIMMD4 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      ESIMMD3OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10023'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMMD3'                                CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD4 = *BLANKS and ESIMMD5 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      ESIMMD4OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10022'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMMD4'                                CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD4 = *BLANKS and ESIMMD5 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      ESIMMD4OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10022'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMMD4'                                CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD5 = *BLANKS and ESIMMD6 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      ESIMMD5 = 'N'                                             CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10021'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMMD5'                                CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD5 = *BLANKS and ESIMMD6 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      ESIMMD5 = 'N'                                             CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10021'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMMD5'                                CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD6 = *BLANKS and ESIMMD7 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      ESIMMD6OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10020'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMMD6'                                CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD6 = *BLANKS and ESIMMD7 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      ESIMMD6OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10020'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMMD6'                                CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD7 = *BLANKS and ESIMMD8 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      ESIMMD7OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10019'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMMD7'                                CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD7 = *BLANKS and ESIMMD8 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      ESIMMD7OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10019'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMMD7'                                CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMMD8 = *BLANKS and ESIMMD9 <> *BLANKS and              CSW206D
     C**********                   WERROR <> 'Y'                                             CSW206D
     C**********         EVAL      ESIMMD8OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10018'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMMD8'                                CSW206D
     C**********         EVAL      WERROR = 'Y'                                              CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMMD8 = *BLANKS and ESIMMD9 <> *BLANKS and              CSW206E
     C                             WERROR <> 'Y'                                             CSW206E
     C                   EVAL      ESIMMD8OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10018'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMMD8'                                CSW206E
     C                   EVAL      WERROR = 'Y'                                              CSW206E
     C                   ENDIF                                                               CSW206E
     C                   ENDIF                                                               CSW206E
      *
      ** Check if Intermediary is valid customer or BIC code
      *
     C                   IF        WERROR = 'N'
 
     C                   EVAL      WSIMMD1 = ESIMMD1
     C                   EVAL      WSIMMD2 = ESIMMD2
     C**********         EVAL      WSIMMD3 = ESIMMD3                                         CSW206D
     C**********         EVAL      WSIMMD4 = ESIMMD4                                         CSW206D
     C**********         EVAL      WSIMMD5 = ESIMMD5                                         CSW206D
     C**********         EVAL      WSIMMD6 = ESIMMD6                                         CSW206D
     C**********         EVAL      WSIMMD7 = ESIMMD7                                         CSW206D
     C**********         EVAL      WSIMMD8 = ESIMMD8                                         CSW206D
     C**********         EVAL      WSIMMD9 = ESIMMD9                                         CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      WSIMMD3 = ESIMMD3                                         CSW206E
     C                   EVAL      WSIMMD4 = ESIMMD4                                         CSW206E
     C                   EVAL      WSIMMD5 = ESIMMD5                                         CSW206E
     C                   EVAL      WSIMMD6 = ESIMMD6                                         CSW206E
     C                   EVAL      WSIMMD7 = ESIMMD7                                         CSW206E
     C                   EVAL      WSIMMD8 = ESIMMD8                                         CSW206E
     C                   EVAL      WSIMMD9 = ESIMMD9                                         CSW206E
     C                   ENDIF                                                               CSW206E
 
     C                   MOVEA     WInterMed     @IM
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     1             C                 2 0
 
     C**********         DOW       X < 10                                                    CSW206D
     C**********         DOW       X < 3                                             CSW206D CSW206E
     C                   DOW       X < 10                                                    CSW206E
 
     C                   IF        @IM(X) <> *BLANKS
 
     C                   EVAL      WWIMMD = @IM(X)
     C                   EXSR      SRCUST
     C                   IF        JFIMMD <> *BLANKS
     C                   EVAL      WWIMMD = JFIMMD
     C                   ENDIF
     C                   EVAL      @IM(X) = WWIMMD
 
     C                   IF        (PBICR = 'MIN0246' and WCLAS = 'B') or
     C                             (@RTCD <> *BLANKS) or (WUnqeFlg = 'Y')
 
     C                   MOVE      X             WFldNum
     C     'ESIMMD'      CAT       WFldNum       WFIELD
      *
      ** Select OK flag to set to 'N'
      *
     C                   SELECT
     C                   WHEN      C = 1
     C                   EVAL      ESIMMD1OK = 'N'
     C                   WHEN      C = 3
     C                   EVAL      ESIMMD2OK = 'N'
     C**********         WHEN      C = 5                                                     CSW206D
     C**********         EVAL      ESIMMD3OK = 'N'                                           CSW206D
     C**********         WHEN      C = 7                                                     CSW206D
     C**********         EVAL      ESIMMD4OK = 'N'                                           CSW206D
     C**********         WHEN      C = 9                                                     CSW206D
     C**********         EVAL      ESIMMD5OK = 'N'                                           CSW206D
     C**********         WHEN      C = 11                                                    CSW206D
     C**********         EVAL      ESIMMD6OK = 'N'                                           CSW206D
     C**********         WHEN      C = 13                                                    CSW206D
     C**********         EVAL      ESIMMD7OK = 'N'                                           CSW206D
     C**********         WHEN      C = 15                                                    CSW206D
     C**********         EVAL      ESIMMD8OK = 'N'                                           CSW206D
     C**********         WHEN      C = 17                                                    CSW206D
     C**********         EVAL      ESIMMD9OK = 'N'                                           CSW206D
     C                   WHEN      C = 5                                                     CSW206E
     C                   EVAL      ESIMMD3OK = 'N'                                           CSW206E
     C                   WHEN      C = 7                                                     CSW206E
     C                   EVAL      ESIMMD4OK = 'N'                                           CSW206E
     C                   WHEN      C = 9                                                     CSW206E
     C                   EVAL      ESIMMD5OK = 'N'                                           CSW206E
     C                   WHEN      C = 11                                                    CSW206E
     C                   EVAL      ESIMMD6OK = 'N'                                           CSW206E
     C                   WHEN      C = 13                                                    CSW206E
     C                   EVAL      ESIMMD7OK = 'N'                                           CSW206E
     C                   WHEN      C = 15                                                    CSW206E
     C                   EVAL      ESIMMD8OK = 'N'                                           CSW206E
     C                   WHEN      C = 17                                                    CSW206E
     C                   EVAL      ESIMMD9OK = 'N'                                           CSW206E
     C                   ENDSL
 
     C                   EVAL      Idx = Idx + 1
     C                   IF        WUnqeFlg = 'Y'
     C                   EVAL      MsgIdXAr(Idx) = 'SE10038'
     C                   ELSE
     C                   EVAL      MsgIdXAr(Idx) = 'SE10026'
     C                   ENDIF
     C                   EVAL      FldNamXAr(Idx) = WFIELD
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ADD       2             C
     C                   ADD       1             X
 
     C                   IF        CSW206 = 'Y' and X = 3                                    CSW206E
     C                   EVAL      X = 10                                                    CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDDO
 
     C                   MOVEA     @IM           WInterMed
     C                   ENDIF
 
     C     EValIntm      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST - Check Intermediary Field                             *
      *                                                               *
      *****************************************************************
 
     C     SRCUST        BEGSR
 
     C                   EVAL      WCLAS = 'C'
     C                   EVAL      PKEY1 = WWIMMD
     C                   EVAL      WUnqeFlg = 'N'
     C                   EVAL      JFIMMD = *BLANKS
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** If Return code is not blank then check if entry is a valid BIC code
      *
     C                   IF        @RTCD <> *BLANKS
 
     C                   MOVEL     WWIMMD        PCSID8
     C                   MOVE      WWIMMD        PCSID4
     C                   MOVEL     PCSID4        PCSID3
 
     C                   EVAL      WCLAS = 'B'
 
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PBICR
     C                   PARM                    PCSID8
     C                   PARM                    PCSID3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       PBICC
     C                   PARM      *BLANKS       PBICS
     C                   PARM      *BLANKS       PBICI
 
     C                   IF        PBICR = *BLANKS
     C                             OR PBICR = 'MIN0244' AND
     C                             PBICC = 'Y'
     C                   EVAL      @RTCD = *BLANKS
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WWIMMD = BBCUST
     C                   EVAL      JFIMMD = BBCSID
 
     C                   ENDIF
      *
      ** Check settlement account is unique
      *
     C                   IF        WImFlg = 'Y'
 
     C                   EVAL      WCtr = 1
 
     C**********         DOW       WCtr <= 9                                                 CSW206D
     C**********         DOW       WCtr <= 2                                         CSW206D CSW206E
     C                   DOW       WCtr <= 9                                                 CSW206E
 
     C                   IF        WIMDArr(WCtr) = *BLANKS
     C                   MOVEL     WWIMMD        WIMDArr(WCtr)
     C                   LEAVE
     C                   ELSE
 
     C                   IF        WIMDArr(WCtr) = WWIMMD
     C                   EVAL      WUnqeFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCtr = WCtr + 1
     C                   IF        CSW206 = 'Y' and WCtr = 3                                 CSW206E
     C                   EVAL      WCtr = 10                                                 CSW206E
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
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
(c) Finastra International Limited 2003
