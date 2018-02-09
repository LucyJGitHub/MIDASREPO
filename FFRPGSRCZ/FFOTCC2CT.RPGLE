     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Ccy OTC LUX Conversion-File to Screen Fmt')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCC2CT - FF Currency OTC LUX Conversion-File to Screen Fmt*
      *                                                               *
      *  Function:  This module will convert the details of the       *
      *             extension file FFTRX2L0 to screen format.         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - Lux Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
 
     D OTCCLUXFilFmt E DS                  EXTNAME(FFTRX2L0)
      ** Futures & Options File Extension
 
     D OTCCLUXScnFmt E DS                  EXTNAME(FFOTRXPD)
      ** Futures & Options Screen Extension
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** parameter fields
 
     D PRetCodeIn      S             10
     D PTrxRef         S              6
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialization
      *
     C                   EXSR      SRINIT
      *
      ** Set screen fields
      *
     C                   EXSR      SRSETFLD
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  SRSETFLD - Set Screen Fields
      *
      *****************************************************************
     C     SRSETFLD      BEGSR
      *
      ** Time
      *
     C                   MOVE      FFTIME        L6LXTIME
      *
      ** Excluded from CAB Reporting
      *
     C                   EVAL      L6LXCABR = FFCABR
     C
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * SRINIT - Initialization
      *
      *****************************************************************
     C     SRINIT        BEGSR
 
     C                   CLEAR                   OTCCLUXScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * *INZSR - Initial Processing                                   *
      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Return code
      *
     C                   PARM                    PRetCodeIn
      *
      ** Transaction Reference
      *
     C                   PARM                    PTrxRef
      *
      ** FFTRX2L0 Extension File Format
      *
     C                   PARM                    OTCCLUXFilFmt
      *
      ** Outputs
      *
      ** FFOTEXPD Extension Screen Format
      *
     C                   PARM                    OTCCLUXScnFmt
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'FFOTCC2CT'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
