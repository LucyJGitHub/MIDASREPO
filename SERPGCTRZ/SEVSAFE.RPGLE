     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Safekeeping Accounts')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVSAFE - Validate Safekeeping Accounts                      *
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
      *                 CSE045  *CREATE    Date 24Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
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
      ** Validate Safekeeping Accounts
      *
     C                   EXSR      SRValSafe
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C     ESIMSA1OK     IFEQ      'N'
     C     ESIMSA2OK     OREQ      'N'
     C*****ESIMSA3OK     OREQ      'N'                                                       CSW206D
     C*****ESIMSA4OK     OREQ      'N'                                                       CSW206D
     C*****ESIMSA5OK     OREQ      'N'                                                       CSW206D
     C*****ESIMSA6OK     OREQ      'N'                                                       CSW206D
     C*****ESIMSA7OK     OREQ      'N'                                                       CSW206D
     C*****ESIMSA8OK     OREQ      'N'                                                       CSW206D
     C*****ESIMSA9OK     OREQ      'N'                                                       CSW206D
     C     ESIMSA3OK     OREQ      'N'                                                       CSW206E
     C     ESIMSA4OK     OREQ      'N'                                                       CSW206E
     C     ESIMSA5OK     OREQ      'N'                                                       CSW206E
     C     ESIMSA6OK     OREQ      'N'                                                       CSW206E
     C     ESIMSA7OK     OREQ      'N'                                                       CSW206E
     C     ESIMSA8OK     OREQ      'N'                                                       CSW206E
     C     ESIMSA9OK     OREQ      'N'                                                       CSW206E
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        ESIMSA1OK <> 'N'
     C                   MOVEL     ESIMSA1       T2IMS1
     C                   ENDIF
 
     C                   IF        ESIMSA2OK <> 'N'
     C                   MOVEL     ESIMSA2       T2IMS2
     C                   ENDIF
 
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                                                                                       CSW206E
     C**********         IF        ESIMSA3OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMSA3       T2IMS3                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA3OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMSA3       T2IMS3                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA4OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMSA4       T2IMS4                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA4OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMSA4       T2IMS4                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA5OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMSA5       T2IMS5                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA5OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMSA5       T2IMS5                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA6OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMSA6       T2IMS6                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA6OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMSA6       T2IMS6                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA7OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMSA7       T2IMS7                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA7OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMSA7       T2IMS7                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA8OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMSA8       T2IMS8                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA8OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMSA8       T2IMS8                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA9OK <> 'N'                                          CSW206D
     C**********         MOVEL     ESIMSA9       T2IMS9                                      CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA9OK <> 'N'                                          CSW206E
     C                   MOVEL     ESIMSA9       T2IMS9                                      CSW206E
     C                   ENDIF                                                               CSW206E
 
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALSAFE - Validation for Safekeeping Accounts              *
      *                                                               *
      *****************************************************************
 
     C     SRValSafe     BEGSR
      *
      ** Corresponding Intermediary field should not be blank
      *
     C                   IF        ESIMSA1 <> *BLANKS and ESIMMD1 = *BLANKS
     C                   EVAL      ESIMSA1OK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'SE10009'
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA1'
     C                   ENDIF
 
     C                   IF        ESIMSA2 <> *BLANKS and ESIMMD2 = *BLANKS
     C                   EVAL      ESIMSA2OK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr(Idx) = 'SE10010'
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA2'
     C                   ENDIF
 
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                                                                                       CSW206E
     C**********         IF        ESIMSA3 <> *BLANKS and ESIMMD3 = *BLANKS                  CSW206D
     C**********         EVAL      ESIMSA3OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10011'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMSA3'                                CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA3 <> *BLANKS and ESIMMD3 = *BLANKS                  CSW206E
     C                   EVAL      ESIMSA3OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10011'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA3'                                CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA4 <> *BLANKS and ESIMMD4 = *BLANKS                  CSW206D
     C**********         EVAL      ESIMSA4OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10012'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMSA4'                                CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA4 <> *BLANKS and ESIMMD4 = *BLANKS                  CSW206E
     C                   EVAL      ESIMSA4OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10012'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA4'                                CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA5 <> *BLANKS and ESIMMD5 = *BLANKS                  CSW206D
     C**********         EVAL      ESIMSA5OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10013'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMSA5'                                CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA5 <> *BLANKS and ESIMMD5 = *BLANKS                  CSW206E
     C                   EVAL      ESIMSA5OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10013'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA5'                                CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA6 <> *BLANKS and ESIMMD6 = *BLANKS                  CSW206D
     C**********         EVAL      ESIMSA6OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10014'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMSA6'                                CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA6 <> *BLANKS and ESIMMD6 = *BLANKS                  CSW206E
     C                   EVAL      ESIMSA6OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10014'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA6'                                CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA7 <> *BLANKS and ESIMMD7 = *BLANKS                  CSW206D
     C**********         EVAL      ESIMSA7OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10015'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMSA7'                                CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA7 <> *BLANKS and ESIMMD7 = *BLANKS                  CSW206E
     C                   EVAL      ESIMSA7OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10015'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA7'                                CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA8 <> *BLANKS and ESIMMD8 = *BLANKS                  CSW206D
     C**********         EVAL      ESIMSA8OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10016'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMSA8'                                CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA8 <> *BLANKS and ESIMMD8 = *BLANKS                  CSW206E
     C                   EVAL      ESIMSA8OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10016'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA8'                                CSW206E
     C                   ENDIF                                                               CSW206E
 
     C**********         IF        ESIMSA9 <> *BLANKS and ESIMMD9 = *BLANKS                  CSW206D
     C**********         EVAL      ESIMSA9OK = 'N'                                           CSW206D
     C**********         EVAL      Idx = Idx + 1                                             CSW206D
     C**********         EVAL      MsgIdXAr(Idx) = 'SE10017'                                 CSW206D
     C**********         EVAL      FldNamXAr(Idx) = 'ESIMSA9'                                CSW206D
     C**********         ENDIF                                                               CSW206D
     C                   IF        ESIMSA9 <> *BLANKS and ESIMMD9 = *BLANKS                  CSW206E
     C                   EVAL      ESIMSA9OK = 'N'                                           CSW206E
     C                   EVAL      Idx = Idx + 1                                             CSW206E
     C                   EVAL      MsgIdXAr(Idx) = 'SE10017'                                 CSW206E
     C                   EVAL      FldNamXAr(Idx) = 'ESIMSA9'                                CSW206E
     C                   ENDIF                                                               CSW206E
 
     C                   ENDIF                                                               CSW206E
                                                                                             CSW206E
     C     EValSafe      ENDSR
 
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
