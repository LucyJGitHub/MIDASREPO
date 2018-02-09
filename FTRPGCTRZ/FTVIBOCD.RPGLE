     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP Bank Operation Code')             *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIBOCD - Validate IP Bank Operation Code                   *
      *                                                               *
      *  Function:  This module validates Bank Operation Code. This   *
      *             is a component of FTIPAYCTL, FTIPAYRPR, FTIPAYSIN,*
      *             and service program for level 2 validation        *
      *             modules.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of dbase error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      /COPY FTCPYSRC,SFTVALCSLE
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Incoming Payments Lvl 2 Scrn 2 details
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)
 
      ** Incoming Payments Valid extension file
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)
 
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     D OKIPY3DS      E DS                  EXTNAME(FTEIPY3PD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error messages
     D Idx             S              3P 0
 
      **
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EVAL      Idx = 0
 
     C                   EXSR      SRBOCD
 
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRBOCD - Validation of Bank Operation Code.                  *
      *****************************************************************
     C     SRBOCD        BEGSR
 
      *
      ** If blank, default to 'CRED'
 
     C                   IF        DDBOCD  = *BLANKS
     C                   EVAL      DDBOCD = 'CRED'
     C                   EVAL      I2INBOCD = 'CRED'
     C                   GOTO      EXBOCD
     C                   ENDIF
 
      *
      ** Otherwise, Bank Operation Code can only be 'CRED', 'SPAY',
      **    'SSTD', or 'SPRI'
 
     C                   IF        (DDBOCD <> 'CRED') AND
     C                             (DDBOCD <> 'SPAY') AND
     C                             (DDBOCD <> 'SSTD') AND
     C                             (DDBOCD <> 'SPRI')
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdXAr = 'FTM5009'
     C                   EVAL      FldNamXAr(Idx) = 'DDBOCD'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKBOCD = 'N'
     C                   ENDIF
 
     C                   IF        ErrorFound = 'N'
     C                   EVAL      I2INBOCD = DDBOCD
     C                   ENDIF
 
     C     EXBOCD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** O: Return Code
     C                   PARM                    ReturnCode
      ***********
      ** INPUT **
      ***********
      ** Incoming Payments Lvl 2 Scrn 2 details
     C                   PARM                    NwIP4ScnFmt
      ************
      ** OUTPUT **
      ************
      ** Incoming Payments Valid extension file
     C                   PARM                    NwIP2FilFmt
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    OKIPY3DS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** ==============================================================
      ** Program, module and procedure names for database error proc'g.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
