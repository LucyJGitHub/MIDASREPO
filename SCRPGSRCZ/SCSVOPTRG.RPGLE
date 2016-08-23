     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Synchronize JNSTAT, TAPOPT and SCSVOPTPD')    *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                               *
      *                                                               *
      *  SCSVOPTRG - Synchronisation of data areas (JNSTAT & TAPOPT)  *
      *              and file SCSVOPTPD                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF002  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF002 - BF Infrastructure: Backup and Recovery              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **
      ** Save Options Configuration file
     FSCSVOPTPD IF   E             DISK
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
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
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for data area JNSTAT
     D JNSTAT        E DS           200    EXTNAME(JNSTAT) DTAARA(JNSTAT)
 
      ** Data structure for data area TAPOPT
     D DSTAPT         UDS             5    DTAARA(TAPOPT)
     D   DSTAPO                1      5
 
      ** Dummy data structure - short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Update data areas JNSTAT and TAPOPT with values from SCSVOTPD
 
     C                   EXSR      SRPROC
 
      ** Exit program
 
     C                   EXSR      SREXIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRPROC - Update of data areas JNSTAT and TAPOPT              *
      *****************************************************************
     C     SRPROC        BEGSR
 
      ** Read SCSVOPTPD file
 
     C                   READ      SCSVOPTPD                              60
 
      ** If no record on file, clear data areas JNSTAT and TAPOPT
     C                   IF        *IN60 = *ON
 
     C     *LOCK         IN        JNSTAT
     C                   EVAL      JNSTAT = ' '
     C                   OUT       JNSTAT
 
     C     *LOCK         IN        DSTAPT
     C                   EVAL      TAPOPT = ' '
     C                   OUT       DSTAPT
 
      ** If no record found, database error
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Update JNSTAT
 
     C     *LOCK         IN        JNSTAT
     C                   EVAL      ARCV = SOARCV
     C                   EVAL      NRCV = SONRCV
     C                   EVAL      DFRS = SODFRS
     C                   EVAL      NDRS = SONDRS
     C                   EVAL      DFBB = SODFBB
     C                   EVAL      NDBB = SONDBB
     C                   EVAL      DFIC = SODFIC
     C                   EVAL      NDIC = SONDIC
     C                   EVAL      VNIC = SOVNIC
     C                   EVAL      DRBB = SODRBB
     C                   EVAL      RCVP = SORCVP
     C                   EVAL      DUAL = SODUAL
     C                   EVAL      SUCC = SOSUCC
     C                   EVAL      VLIC = SOVLIC
     C                   EVAL      DSIN = SODSIN
     C                   EVAL      RDBV = SORDBV
     C                   EVAL      BKPS = SOBKPS
     C                   EVAL      RCVR = SORCVR
     C                   EVAL      RCVA = SORCVA
     C                   EVAL      PRUN = SOPRUN
     C                   EVAL      AUTR = SOAUTR
     C                   EVAL      JASP = SOJASP
     C                   EVAL      RASP = SORASP
     C                   EVAL      DDDB = SODDDB
     C                   EVAL      VDTB = SOVDTB
     C                   EVAL      RSTFSV = SORFSV
     C                   EVAL      SAVGLO = SOSGLO
     C                   EVAL      TAPOPT = SOTOPT
     C                   OUT       JNSTAT
 
      ** Update TAPOPT
 
     C     *LOCK         IN        DSTAPT
     C                   EVAL      DSTAPO = SOTAOP
     C                   OUT       DSTAPT
 
     C                   ENDIF
 
      ** Read SCSVOPTPD again to check if more than 1 record exists
 
     C                   READ      SCSVOPTPD                              60
 
      ** If another record is found, database error
 
     C                   IF        *IN60 = *OFF
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SREXIT - Exit program                                        *
      *****************************************************************
     C     SREXIT        BEGSR
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   EVAL      DBPGM = 'SCSVOPTRG'
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
