     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV WI/WO Extended Settlement - Retrieve')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEDMESRTV - Depot Movement Extension & Extended        *
      *                    Settlement Retrieve                        *
      *                                                               *
      *  Function:  This module retrieves these two extension files   *
      *             from the database. It doesn't validate the action *
      *             code nor the key fields, as this should have been *
      *             done by the main retrieve module SEDPMVRTV for    *
      *             the base file.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP087             Date 12Sep05               *
      *                 222727             Date 05Nov03               *
      *                 CSE045  *CREATE    Date 06Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDPTMVDY1  IF   E           K DISK    INFSR(*PSSR)
      ** Depot Movement Extension by Security
 
     FDPTMVDY2  IF   E           K DISK    INFSR(*PSSR)
      ** Depot Movement Extended Settlement
 
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D SEDMX1        E DS                  EXTNAME(DPTMVDX1)
      ** Extension File in file format
 
     D SEDMX2        E DS                  EXTNAME(DPTMVDX2)
      ** Extended Settlement File in file format
      ** MT5xx information part
     D   SEDMX2MT5xx        1121   1490A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ subroutine is executed at program activation.              ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EXSR      Init
      *
     C                   EXSR      RtvDMXn
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * RtvDMXn - Retrieve Extensions Details
      *****************************************************************
     C     RtvDMXn       BEGSR
      *
      ** Access files (no problem if not found, DS have been cleared)
      *
     C     KDPTMVDXn     CHAIN     DPTMVDD1
     C     KDPTMVDXn     CHAIN     DPTMVDD2
      *
      ** If CSE028 is off, the MT5xx data shouldn't exist
      *
     C                   IF        CSE028 <> 'Y'
     C                   EVAL      SEDMX2MT5xx = *Blanks
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear Outputs
      *
     C                   CLEAR                   SEDMX1
     C                   CLEAR                   SEDMX2
      *
      ***Set*the*third*key*field*according*with*CSW003*Status                                 CAP087
      *******************************************************                                 CAP087
     C*******************IF        CSW003 = 'Y'                                               CAP087
      ** Do not condition with CSW003 - When Produced field is always set to 'S' anyway.      CAP087
     C                   EVAL      WWWHEN = 'S'
     C*******************ELSE                                                                 CAP087
     C*******************EVAL      WWWHEN = *Blank                                            CAP087
     C*******************ENDIF                                                                CAP087
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM      *Blanks       RetCodeIn
      ** Movement references
     C                   PARM                    DDDPSS           10
     C                   PARM                    DDDPRN            6
      ** Features
     C                   PARM                    CSE028            1
     C                   PARM                    CSW003            1
      *
      ** OUTPUT PARAMETERS
      ** Extension and Extended Settlement details
     C                   PARM                    SEDMX1
     C                   PARM                    SEDMX2
      *
      ** KLIST's
      *
     C     KDPTMVDXn     KLIST
     C                   KFLD                    DDDPSS
     C                   KFLD                    DDDPRN
     C                   KFLD                    WWWHEN            1
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
