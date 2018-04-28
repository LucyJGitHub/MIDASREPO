     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV WI/WO Extended Settlement - Update')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEDMESUPD - Depot Movement WI/WO extension & extended  *
      *                    settlement - Database Update               *
      *                                                               *
      *  Note: As this module only updates extension files for a      *
      *        WI/WO Movement, it only writes or updates a record in  *
      *        each of these files. The validity chekings, such as    *
      *        "check for other updates", should already have been    *
      *        done for the main record, and there is no functionnal  *
      *        need to repeat them for each extension file.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 222727             Date 05Nov03               *
      *                 CSE045  *CREATE    Date 06Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDPTMVDY1  UF A E           K DISK    COMMIT INFSR(*PSSR)
      ** Depot Movement Extension by Security
 
     FDPTMVDY2  UF A E           K DISK    COMMIT INFSR(*PSSR)
      ** Depot Movement Extended Settlement
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
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
 
     D ValidDMX1     E DS                  EXTNAME(SEVDMX1PD)
      ** Valid Extension file record
 
     D ValidDMX2     E DS                  EXTNAME(SEVDMX2PD)
      ** Valid Extended Settlement file record
 
     D SEDMX1        E DS                  EXTNAME(DPTMVDX1)
      ** Extension file record
 
     D SEDMX2        E DS                  EXTNAME(DPTMVDX2)
      ** Extended Settlement file record
 
     D ClearDMX2     E DS                  EXTNAME(SEVDMX2PD) PREFIX(C:1)
      ** Empty Extended Settlement file record
 
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
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ subroutine is executed at program activation.              ¦
      ** +------------------------------------------------------------+
      *
      ** Insert or Amend the extension records
      *
     C                   EXSR      Updates
      *
      * Exit From Program
      *
     C                   RETURN
      *
      ****************************************************************
      /EJECT
      ****************************************************************
      * Updates - Insert or Amend records in the two extension files
      ****************************************************************
     C     Updates       BEGSR
      *
      ** Extension file DPTMVDX1
      ** Access the record
      *
     C     KDPTMVDXn     CHAIN     DPTMVDD1                           99
      *
      ** Initialize the record
      *
     C                   MOVE      ValidDMX1     SEDMX1
      ** Time of last update
     C                   TIME                    DPTIME
      ** Last Change Date
     C                   EVAL      DPLCD = BJRDNB
      *
      ** Write/Update the record
      *
     C   99              WRITE     DPTMVDD1
     C  N99              UPDATE    DPTMVDD1
      *
      ** Extended Settlement file DPTMVDX2 (may not exist)
      ** Access the record
      *
 B1  C                   IF        ValidDMX2 <> ClearDMX2
     C     KDPTMVDXn     CHAIN     DPTMVDD2                           99
      *
      ** Initialize the record
      *
     C                   MOVE      ValidDMX2     SEDMX2
      *
      ** Write/Update the record
      *
     C   99              WRITE     DPTMVDD2
     C  N99              UPDATE    DPTMVDD2
 E1  C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program Parameters
      *
     C     *ENTRY        PLIST
      ** Return Code
     C                   PARM                    @@RTCD            7
      ** Extension and Extended Settlement details
     C                   PARM                    ValidDMX1
     C                   PARM                    ValidDMX2
      ** Run Date Number
     C                   PARM                    BJRDNB            5 0
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Klist's
      *
     C     KDPTMVDXn     KLIST
     C                   KFLD                    VDPDPSS
     C                   KFLD                    VDPDPRN
     C                   KFLD                    VDPWHEN
      *
      ** Initialize values of the empty Extended Settlement record
      *
     C                   CLEAR                   ClearDMX2
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
