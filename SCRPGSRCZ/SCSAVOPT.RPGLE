     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Save Options Config. - Initialisation')       *
      *****************************************************************
      *                                                               *
      *   Midas - System Control Module                               *
      *                                                               *
      *   SCSAVOPT -  Initialise Save Options Configuration File      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD045558           Date 12May17               *
      *  Prev Amend No. CBF002  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD045558 - Component SCCSAVOPTA 00001 produces dump during   *
      *             COB due to Lock for JNSTAT not granted            *
      *  CBF002 - BF Infrastructure: Backup and Recovery              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSCSVOPTPD UF A E             DISK    USROPN
      ** Save Options Configuration File

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** JNSTAT Data Area
     D***JNSTAT*          UDS           200                                                 MD045558
     DJNSTAT           DS           200                                                     MD045558
     D ARCV                    1     10
     D NRCV                   11     20
     D DFRS                   21     24
     D NDRS                   25     34
     D DFBB                   35     38
     D NDBB                   39     48
     D DFIC                   49     52
     D NDIC                   53     62
     D VNIC                   63     67
     D DRBB                   68     68
     D RCVP                   69     69
     D DUAL                   70     70
     D SUCC                   74     74
     D VLIC                   75     79
     D DSIN                   80     80
     D RDBV                   81     81
     D BKPS                   82     82
     D RCVR                   83     92
     D RCVA                   93    102
     D PRUN                  103    105P 0
     D AUTR                  106    110
     D JASP                  149    150
     D RASP                  151    152
     D DDDB                  153    162
     D VDTB                  163    170
     D RSTFSV                171    171
     D SAVGLO                172    172
     D TAPOPT                173    173

     D CmdStr          S           1024
     D CmdLen          S             15  5
     D @RUN            S              1
     D PRTCD           S              7

      *****************************************************************
      /EJECT
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD

      ** Mainline Routine

     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        JNSTAT

     C                   OPEN      SCSVOPTPD                            91

     ** Open Error
     C     *IN91         CABEQ     '1'           TSKIP

     C                   IF        JNSTAT = *BLANKS
     C                   CLOSE     SCSVOPTPD                            92

      ** Close Error
     C     *IN92         CABEQ     '1'           TSKIP

     C                   EVAL      CmdStr = 'CLRPFM FILE' +
     C                                      '(*LIBL/SCSVOPTPD)'
     C                   EVAL      CmdLen = 28

     C                   CALL      'QCMDEXC'
     C                   PARM                    CmdStr
     C                   PARM                    CmdLen

     C                   ELSE

     C                   READ      SCSVOPTF                             9093

      ** File Error
     C     *IN90         CABEQ     '1'           TSKIP

     C                   EXSR      SRPROCESS

     C                   IF        *IN93 = *ON
     C                   WRITE     SCSVOPTF
     C                   ELSE
     C                   UPDATE    SCSVOPTF
     C                   ENDIF

     C                   ENDIF

     C                   CLOSE     SCSVOPTPD                            92

      ** Close Error
     C     *IN92         CABEQ     '1'           TSKIP

     C     TSKIP         TAG

     C                   MOVE      *BLANK        PRTCD
     C   90              MOVE      '*ERROR '     PRTCD
     C   91              MOVE      '*OPEN  '     PRTCD
     C   92              MOVE      '*CLOSE '     PRTCD

     C                   IF        PRTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPROCESS - Initialise/Update JNSTAT fields                   *
      *****************************************************************
     C     SRPROCESS     BEGSR

     C                   EVAL      SOARCV = ARCV
     C                   EVAL      SONRCV = NRCV
     C                   EVAL      SODFRS = DFRS
     C                   EVAL      SONDRS = NDRS
     C                   EVAL      SODFBB = DFBB
     C                   EVAL      SONDBB = NDBB
     C                   EVAL      SODFIC = DFIC
     C                   EVAL      SONDIC = NDIC
     C                   EVAL      SOVNIC = VNIC
     C                   EVAL      SODRBB = DRBB
     C                   EVAL      SORCVP = RCVP
     C                   EVAL      SODUAL = DUAL
     C                   EVAL      SOSUCC = SUCC
     C                   EVAL      SOVLIC = VLIC
     C                   EVAL      SODSIN = DSIN
     C                   EVAL      SORDBV = RDBV
     C                   EVAL      SOBKPS = BKPS
     C                   EVAL      SORCVR = RCVR
     C                   EVAL      SORCVA = RCVA
     C                   EVAL      SOPRUN = PRUN
     C                   EVAL      SOAUTR = AUTR
     C                   EVAL      SOJASP = JASP
     C                   EVAL      SORASP = RASP
     C                   EVAL      SODDDB = DDDB
     C                   EVAL      SOVDTB = VDTB
     C                   EVAL      SORFSV = RSTFSV
     C                   EVAL      SOSGLO = SAVGLO
     C                   EVAL      SOTOPT = TAPOPT

     C                   IF        TAPOPT = 'Y'
     C                   EVAL      SOTAOP = 'SYSID'
     C                   ELSE
     C                   EVAL      SOTAOP = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Mainline Routine                                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
