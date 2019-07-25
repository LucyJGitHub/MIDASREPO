     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC PEA Control Screen')                          *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000118 - PEA Control Screen                                *
      *                                                               *
      *  Function:  This program is called as a control confirmation  *
      *             screen for starting the MQ Handshaking program    *
      *             and calling PEA transaction resend program.       *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC054 - Periodic End Adjustments.                           *
      *                                                               *
      *****************************************************************

      ** Midas SC PEA Control Screen Display File

     FSC000118DFCF   E             WORKSTN

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

     D PEAInd          C                   CONST('PEAIndicator')

      ** Text constants

     D CTEXT1          C                   CONST('MQ Handshaking Liste-
     D                                     ner (monitor) will be resta-
     D                                     rted')
     D CTEXT2          C                   CONST('MQ Handshaking Liste-
     D                                     ner (updater) will be resta-
     D                                     rted')
     D CTEXT3          C                   CONST('MQ Handshaking Liste-
     D                                     ner (monitor) will be ended-
     D                                     ')
     D CTEXT4          C                   CONST('MQ Handshaking Liste-
     D                                     ner (updater) will be ended-
     D                                     ')
     D CTEXT5          C                   CONST('Transaction data wil-
     D                                     l be resent to the LIVE sys-
     D                                     tem')
     D CTEXT6          C                   CONST('Transaction data wil-
     D                                     l be resent to the Period E-
     D                                     nd Adjustment system')
     D CTEXT7          C                   CONST('Option only availabl-
     D                                     e if Period End Adjustment -
     D                                     system is CLOSED')

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

     D PAction         S             10A
     D PProgram        S             10A

     D WPEAInd         S              1A
     D WValid          S              1A
     D WPos            S              2P 0
     D WTxt            S             78A
     D SCPEAMON        S              1A   DTAARA(SCPEAMON)

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************

     C                   IN        RUNDAT
     C                   EVAL      USER     = PSUser
     C                   EVAL      WSID     = PSJobName
     C                   EVAL      RUNA     = AGMRDT

     C                   EVAL      WValid   = 'Y'

     C                   SELECT
     C                   WHEN      PAction  = 'MQ_START'
     C                   IF        WPEAInd  = 'Y'
     C                   EVAL      WTxt     = CTEXT1
     C                   EXSR      SRAlign
     C                   EVAL      PPRogram = 'SCC000113'
     C                   ENDIF

     C                   IF        WPEAInd  = 'N'
     C                   EVAL      WTxt     = CTEXT2
     C                   EXSR      SRAlign
     C                   EVAL      PPRogram = 'SCC000115'
     C                   ENDIF

     C                   WHEN      PAction  = 'MQ_STOP'

     C                   IF        WPEAInd  = 'Y'
     C                   EVAL      WTxt     = CTEXT3
     C                   EXSR      SRAlign
     C                   EVAL      PPRogram = 'GOC000113'
     C                   ENDIF

     C                   IF        WPEAInd  = 'N'
     C                   EVAL      WTxt     = CTEXT4
     C                   EXSR      SRAlign
     C                   EVAL      PPRogram = 'GOC000114'
     C                   ENDIF

     C                   WHEN      PAction  = 'MQ_RESEND'

     C                   IF        WPEAInd  = 'Y'

      ** Check if PEA status is CLOSED

     C                   IN        SCPEAMON
     C                   IF        SCPEAMON  <> 'C'
     C                   EVAL      WTxt     = CTEXT7
     C                   EXSR      SRAlign
     C                   EVAL      WValid   = 'N'
     C                   ELSE
     C                   EVAL      WTxt     = CTEXT5
     C                   EXSR      SRAlign
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WTxt     = CTEXT6
     C                   EXSR      SRAlign
     C                   ENDIF
     C                   EVAL      PPRogram = 'SCC000117'
     C                   ENDSL

      ** Loop until F3 or ENTER is pressed

     C                   DOU       *IN03  = *ON
     C                             OR *IN10 = *OFF

     C                   EXFMT     SC000118F0

     C                   IF        *IN03  = *OFF
     C                             AND *IN10   = *OFF
     C                             AND WValid  = 'Y'

     C                   CALL(E)   PProgram

     C                   IF        %ERROR()
     C                   EVAL      *IN10  = *ON
     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PAction

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      PEAInd        PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
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

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlign - Align text to screen.                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     SRAlign       BEGSR
     C                   EVAL      WPos = (78-%LEN(%TRIMR(WTxt)))/2+1
     C                   EVAL      RTXT = *BLANKS
     C                   EVAL      %SUBST(RTXT:WPos) = WTxt
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
