     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC PEA Set System Status')                       *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000117 - PEA Set System Status                             *
      *                                                               *
      *  Function:  This program is called to set the PEA system      *
      *             status to either OPEN or CLOSED.                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD020167           Date 23Apr13               *
      *  Prev Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CSC054 - Periodic End Adjustments.                           *
      *                                                               *
      *****************************************************************

      ** Midas SC PEA System Status File

     FSCPEASPD  UF A E           K DISK    USROPN

      ** Midas GP Downloaded data from zones

     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN

      ** Midas SC PEA System Status Display

     FSC000117DFCF   E             WORKSTN

      *****************************************************************
      /EJECT
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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

      ** Constant to hold input parameter for AOSVALR0.

     D PEAInd          C                   Const('PEAIndicator')
     D PEALivePrefix   C                   Const('PEALiveSystemPrefix')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Midas SD Rundate Data Area

     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)

      ** Midas SC Phase of day

     D MPHASE        E DS                  EXTNAME(MPHAS) DTAARA(MPHAS)

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRtCd           S              7A
     D PSysVal01       S             20A
     D PCurSet01       S            200A
     D PSysVal02       S             20A
     D PCurSet02       S            200A
     D PSysVal03       S             20A
     D PCurSet03       S            200A
     D PSysVal04       S             20A
     D PCurSet04       S            200A
     D PSysVal05       S             20A
     D PCurSet05       S            200A
     D PSysVal06       S             20A
     D PCurSet06       S            200A
     D PSysVal07       S             20A
     D PCurSet07       S            200A
     D PSysVal08       S             20A
     D PCurSet08       S            200A
     D PSysVal09       S             20A
     D PCurSet09       S            200A
     D PSysVal10       S             20A
     D PCurSet10       S            200A

     D PAction         S              1A

     D WPEAInd         S              1A
     D WLive           S              2A
     D WStat           S             10A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************

     C                   IN        MPHASE

     C                   IF        MPHAS   = 'A'

     C                   IN        RUNDAT
     C                   EVAL      USER    = PSUser
     C                   EVAL      WSID    = PSJobName
     C                   EVAL      RUNA    = AGMRDT

     C                   IF        WPEAInd = 'N'

     C                   EVAL      RTXT = '  Period End Adjustment'
     C                                  + ' System Status will be'

     C                   IF        PAction = 'O'
     C                   EVAL      RTXT    = %TRIMR(RTXT) + ' OPENED.'
     C                   ELSE
     C                   EVAL      RTXT    = %TRIMR(RTXT) + ' CLOSED.'
     C                   ENDIF

     C                   ELSE

     C                   EVAL      RTXT = '    This option is only'
     C                             + ' available on the LIVE system'

     C                   ENDIF

      ** Loop until F3 or ENTER key is pressed

     C                   DOU       *IN03  = *ON
     C                             OR *IN10 = *OFF

     C                   EXFMT     SC000117F0

     C                   IF        *IN03  = *OFF
     C                             AND *IN10   = *OFF
     C                             AND WPEAInd = 'N'
     C                   OPEN      SCPEASPD
     C     *START        SETLL     SCPEASPD
     C                   READ      SCPEASPD
     C                   EVAL      PESTAT = PAction
     C                   IF        %EOF
     C                   WRITE     SCPEASD0
     C                   ELSE
     C                   UPDATE    SCPEASD0
     C                   ENDIF
     C                   CLOSE     SCPEASPD
     C                   ENDIF

      ** Update GP Downloaded data file

     C                   IF        PAction =  'O'
     C                   EVAL      WStat   =  'OPEN'
     C                   ELSE
     C                   EVAL      WStat   =  'CLOSED'
     C                   ENDIF

     C                   EVAL      DLMSID  =  WLive
     C                   EVAL      DLKEYD  = 'PEASystemStatus'

     C                   OPEN      GPDWNLL0
     C     GPDWNLL0Key   CHAIN     GPDWNLL0
     C                   IF        %FOUND
     C                   EVAL      DLVAL   = WStat
     C                   UPDATE    @DWNLL0
     C                   ELSE
     C                   EVAL      DLMSID  = WLive
     C                   EVAL      DLKEYD  = 'PEASystemStatus'
     C                   EVAL      DLVAL   = WStat
     C                   EVAL      DLMPGM  = '*NONE'
     C                   EVAL      DLMPRM  = *BLANKS
     C                   EVAL      DLEPGM  = '*NONE'
     C                   EVAL      DLEPRM  = *BLANKS
     C                   WRITE     @DWNLL0
     C                   ENDIF
     C                   CLOSE     GPDWNLL0

     C                   ENDDO

     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PAction

     C     GPDWNLL0Key   KLIST
     C                   KFLD                    DLMSID
     C                   KFLD                    DLKEYD

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      PEAInd        PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM      PEALivePrefix PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10

     C                   IF        PrtCd   = *BLANKS
     C                             AND PCurSet01 <> *BLANKS

     C                   EVAL      WPEAInd = PCurSet01
     C                   EVAL      WLive   = PCurSet02

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   IF        RunBefore <> 'Y'
     C
     C                   EVAL      RunBefore = 'Y'
     C
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   RETURN
     C                   ENDSR
