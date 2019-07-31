     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV WI/WO Extended Settlement - Default')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEDMESDFT - Depot Movement WI/WO extension & extended  *
      *                    settlement - Defaulting                    *
      *                                                               *
      *  Function:  This module defaults the fields of the Depot      *
      *             Movement Extension and the Extended Settlement    *
      *             displays (only for WI/WO)                         *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR586519           Date 02Aug10               *
      *                 AR578319           Date 14Jul10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16739           Date 11Mar08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 BUG10087           Date 20Feb06               *
      *                 BUG10120           Date 25Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 03Aug05               *
      *                 CSE045  *CREATE    Date 06Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR586519 - Account for Payment and Account for Payment       *
      *             (detail) not populated from SEST                  *
      *  AR578319 - New fields are being blanked out if CSW210 is on  *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16739 - Time of transaction field should be defaulted     *
      *             if time offset against UTC and System time offset *
      *             has been set up                                   *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  BUG10087 Customer SSI being overwritten by Book SSI.         *
      *  BUG10120 No SSI default being done for Depot Movement.       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           (recompile due to changes in file SEDMWIPD)         *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
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
 
     D DPMVScrFld    E DS                  EXTNAME(SEDMWIPD)
      ** SEDPMV Transaction Details in screen format
     D   Screen1             350    505A
     D***Screen2             506   1908A                                                      CSW210
     D   Screen2             506   1889A                                                      CSW210
 
     D DSSTD         E DS                  OCCURS(2) EXTNAME(STDSED)
      ** Data structure for standard settlement instructions
 
     D DSADD         E DS                  OCCURS(8) EXTNAME(STDADSED)
      ** Data structure for standard additional settlement details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Array used to move right Swift Id.
     D ROU             S              1    DIM(12)
 
     D WTimeStamp      S               Z                                                    BUG16739
     D WTIME           S             26A                                                    BUG16739
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
      ** Retrieve Standard Settlement Instructions if necessary
      *
     C                   IF        CSE028 = 'Y' AND
     C                             (Screen1 = *Blanks OR Screen2 = *Blanks)
     C                   EXSR      SSIRtv
     C                   ENDIF
      *
      ** Determine Network routing and addresses for settlements
      *
     C                   EVAL      WSNDR = DDDPID
     C                   EVAL      WDEST = DDDPID
     C                   EXSR      SR1100
     C                   MOVE      WWGME         SVGMES            1
     C                   EVAL      DDROUS = WWROU
     C                   EVAL      DDROTS = WWROT
      *
      ** Confirmation message indicator should always be 'N' for WI/WO
      ** (see validations), so no need to determine anything
      *
     C                   EVAL      DSROUC = *Blanks
     C                   EVAL      DSROTC = *Blanks
      *
      ** Default screen 1 if necessary
      *
     C                   IF        Screen1 = *Blanks
     C                   EXSR      Scr1Dflt
     C                   ENDIF
                                                                                            BUG16739
      ** Default the run time                                                               BUG16739
                                                                                            BUG16739
     C                   IF        DSTRTT = *BLANKS                                         BUG16739
     C                   CALLB     'ZAGENTMSTM'                                             BUG16739
     C                   PARM                    WTimeStamp                                 BUG16739
     C                   MOVE      WTimeStamp    WTIME                                      BUG16739
                                                                                            BUG16739
     C                   EVAL      DSTRTT = %SUBST(WTIME:12:2) +                            BUG16739
     C                                      %SUBST(WTIME:15:2)                              BUG16739
     C                   ENDIF                                                              BUG16739
      *
      ** Force the value of the ISO15022 indicator (introduced by
      ** CSE029, not displayed when Swift 2002 is on)
      *
     C                   IF        CSE029 = 'N'
     C                   EVAL      DS1522 = 'N'
     C                   ELSE
      *
     C                   IF        CSW202 = 'Y' OR DDACTN = 'I'
     C                   EVAL      DS1522 = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Default screen 2 if necessary
      *
     C                   IF        Screen2 = *Blanks
     C                   EXSR      Scr2Dflt
     C                   ENDIF
      *
      ** Whatever the screen, non-displayed fields should be blanked out
      *
     C                   EXSR      BlankOut
      *
      ** End of module
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SSIRtv - Retrieve Standard Settlement Instructions
      *****************************************************************
     C     SSIRtv        BEGSR
      *
      ** First need to settup input parms for SESSIR0
      *
 B1  C     CSE029        IFNE      'Y'
     C                   MOVE      @SMCC         PMRKT
     C                   MOVE      DDDPBN        PCUST
     C                   ELSE
     C                   MOVE      DDMRKT        PMRKT
     C                   MOVE      WCPTY         PCUST
     C                   ENDIF
      ** Set up to get bank's SSI as well                                                   BUG10087
      *                                                                                     BUG10087
     C                   IF        DDDPBK <> *BLANKS                                        BUG10087
     C                   MOVE      DDDPBK        PBOOK                                      BUG10087
     C                   ELSE                                                               BUG10087
     C                   MOVE      *BLANK        PBOOK                                      BUG10087
     C                   ENDIF                                                              BUG10087
      *
     C                   CALL      'SESSIR0'
      *
      ** INPUT PARAMETERS
      ** Operation type
      ** Branch
      ** Customer
      ** Book
      ** Currency
      ** Market Centre
      ** Investment type
      ** Portfolio reference
      *
     C                   PARM      'D'           POPTYP            1
     C                   PARM      DDDPBA        PBRCH             3
     C                   PARM                    PCUST             6
     C****************** PARM      *BLANKS       PBOOK             2                        BUG10087
     C                   PARM                    PBOOK             2                        BUG10087
     C                   PARM      @NMCY         PCCY              3
     C                   PARM                    PMRKT             2
     C                   PARM      @SITP         PINTYP            3
     C                   PARM      *BLANKS       PPOREF            4
      *
      ** OUTPUT PARAMETERS
      ** Data structure for STDSED (Book and Customer)
      ** Data structure for STDADSED (Book and Customer)
      ** (For physical Depot IN/OUT)
      ** Return code
      *
     C                   PARM                    DSSTD
     C                   PARM                    DSADD
     C                   PARM                    PTRCD             5
      *
      ** Move data returned from call to SESSIR0 to screen fields
      ** Data structure occurence to use depends on movement type.
      ** If return code from SESSIR0 = *NRF then no record was
      ** found so no need to set occurence indicator Z
      *
 B1  C     PTRCD         IFEQ      '*NRF  '
     C                   Z-ADD     0             Z
 X1  C                   ELSE
      *
      ** If occurence 1 of data structure DSSTD is filled then we
      ** have book data so we need to look at occurencs 1-4 of data
      ** structure DSADD.
      ** If occurence 2 of data structure DSSTD is filled then we
      ** have customer data so we need to look at occurencs 5-8 of
      ** structure DSADD.
      *
     C                   MOVE      ' '           @BOOK             1
     C                   MOVE      ' '           @CUST             1
      *
      ** Check if book data
      *
     C     1             OCCUR     DSSTD
      *
 B2  C     SIBK          IFNE      *BLANKS
     C                   MOVE      'Y'           @BOOK
     C*****************  MOVE      'N'           @CUST                                      BUG10087
 E2  C                   ENDIF
      *
      ** Check if customer data
      *
 B2  C*****@BOOK*******  IFNE      'Y'                                                      BUG10087
     C     2             OCCUR     DSSTD
      *
 B3  C*****CSTM*         IFNE      0                                                          CSD027
 B3  C     CSTM          IFNE      *BLANKS                                                    CSD027
     C*****************  MOVE      'N'           @BOOK                                      BUG10087
     C                   MOVE      'Y'           @CUST
 E3  C                   ENDIF
      *
 E2  C*****************  ENDIF                                                              BUG10087
      *
      ** Now work out which occurence of data structure DSADD
      *
     C                   Z-ADD     0             Z                 2 0
      *
 B2  C     STFDM         IFEQ      'Y'
      *
 B3  C                   SELECT
      ** Trade purchase
 X3  C     DPMVType      WHENEQ    'WI'
     C     DPMVType      OREQ      'BB'                                                     BUG10120
     C     DPMVType      OREQ      'PL'                                                     BUG10120
     C     DPMVType      OREQ      'RR'                                                     BUG10120
     C     DPMVType      OREQ      'DT'                                                     BUG10120
     C                   Z-ADD     1             Z
      ** Trade sale
 X3  C     DPMVType      WHENEQ    'WO'
     C     DPMVType      OREQ      'BL'                                                     BUG10120
     C     DPMVType      OREQ      'PD'                                                     BUG10120
     C     DPMVType      OREQ      'RP'                                                     BUG10120
     C                   Z-ADD     2             Z
 E3  C                   ENDSL
      *
 X2  C                   ELSE
      *
 B3  C                   SELECT
      ** Depot in
 X3  C     DPMVType      WHENEQ    'WI'
     C     DPMVType      OREQ      'BB'                                                     BUG10120
     C     DPMVType      OREQ      'PL'                                                     BUG10120
     C     DPMVType      OREQ      'RR'                                                     BUG10120
     C     DPMVType      OREQ      'DT'                                                     BUG10120
     C                   Z-ADD     3             Z
      ** Depot out
 X3  C     DPMVType      WHENEQ    'WO'
     C     DPMVType      OREQ      'BL'                                                     BUG10120
     C     DPMVType      OREQ      'PD'                                                     BUG10120
     C     DPMVType      OREQ      'RP'                                                     BUG10120
     C                   Z-ADD     4             Z
 E3  C                   ENDSL
      *
 E2  C                   ENDIF
      *
      ** For book data then Z setting for occurence 1,2,3 or 4 is fine.
      ** For customer data we need Z to be set to 5,6,7 or 8 so add 4 to
      ** its current value.
      *
 B2  C     @CUST         IFEQ      'Y'
     C                   ADD       4             Z
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SR1100 - Determines network and adresses
      *****************************************************************
     C     SR1100        BEGSR
      *
     C                   CALL      'ZM1100'
     C                   PARM                    WSNDR             6
     C                   PARM      *BLANKS       WSCSD            12
     C                   PARM                    WDEST             6
     C                   PARM      *BLANKS       WSETP             2
     C                   PARM      *BLANKS       WNWSN            20
     C                   PARM      *BLANKS       WNWDS            22
     C                   PARM      *BLANKS       WNWRK             6
     C                   PARM      *BLANKS       WERRC             1
     C                   PARM      *BLANKS       WSRNM            20
     C                   PARM      *BLANKS       WSRTN            10
     C                   PARM      *BLANKS       WDRNM            20
     C                   PARM      *BLANKS       WDRTN            10
      *
 B1  C     WERRC         IFEQ      'S'
     C     WERRC         OREQ      'D'
     C     WNWRK         OREQ      'UNROUT'
     C                   MOVE      'N'           WWGME             1
     C                   MOVEL     *BLANKS       WWROU
     C                   EVAL      WWROT = '  UNROUTABLE'
 X1  C                   ELSE
     C                   MOVE      'Y'           WWGME
     C                   MOVEL     WNWRK         WWROU             6
     C                   MOVEA     WNWDS         ROU
     C                   Z-ADD     1             J                 2 0
     C     ' '           LOOKUP    ROU(J)                                 99
      *
 B2  C                   IF        NOT *IN99
     C                   MOVEL     WNWDS         WWROT            12
 X2  C                   ELSE
     C     14            SUB       J             K                 2 0
     C                   MOVEA     *ALL' '       ROU
     C                   MOVEA     WNWDS         ROU(K)
     C                   MOVEA     ROU           WWROT
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Scr1Dflt - Default first screen
      *****************************************************************
     C     Scr1Dflt      BEGSR
      *
      ** Free/against payment is always 'F'
      *
     C                   MOVE      'F'           DSFIND
      *
     C                   TIME                    WWTIME            6 0
     C                   MOVEL     WWTIME        DSTRTT
      *
      ** Settlement request
      *
     C                   EVAL      DSGMES = SVGMES
      *
      ** Default Settlement request to N if backvaluation
      *
     C                   MOVEL     DDDPMD        ZDATE
     C                   EXSR      ZDATE1
      *
     C     ZDAYNO        IFLT      BJRDNB
     C                   MOVE      'N'           DSGMES
     C                   END
      *
      ** Init Network routing and addresses for confirmations
      *
     C                   MOVE      'N'           DSGMEC
      *
      ** If CSE028 is present then SESSIR0 was called for the
      ** setting up of MT5xx information.
      *
 B1  C     CSE028        IFEQ      'Y'
      *
      ** IF Z not set then we have no data from SESSIR0 so
      ** use normal defaulting (done above)
      *
 B2  C     Z             IFNE      0
      *
     C     Z             OCCUR     DSADD
      ** Settlement message request
     C                   MOVE      SAGMES        DSGMES
      ** ISO15022 Messages indicator
 B3  C     CSE029        IFEQ      'Y'
     C                   MOVE      SNEW          DS1522
 E3  C                   ENDIF
      ** Instruction type
     C                   MOVE      SAINST        DSINST
      ** Instruction sub-type
     C                   MOVE      SAINSS        DSINSS
      ** Safekeeping Account
     C                   MOVEL     SKAC          DSSAFA
      ** Free or against Payment
     C                   MOVE      SAFIND        DSFIND
      ** Requested priority
     C                   MOVE      SARPTY        DSRPTY
      ** Guaranteed delivery
     C                   MOVE      SAGDEL        DSGDEL
      ** Senders role
     C                   MOVE      SASROL        DSSROL
      ** Confirmation message request
     C                   MOVE      SACONG        DSGMEC
      ** Stamp status
     C                   MOVE      SASTMP        DSSTST
      ** Transaction report marker
     C                   MOVE      SATRRM        DSTRRM
      ** Charity identifier
     C                   MOVE      SACHID        DSCHID
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Scr2Dflt - Default second screen with SESSIR0 results
      *****************************************************************
     C     Scr2Dflt      BEGSR
      *
 B1  C                   IF        CSE028 = 'Y' AND Z <> 0
      *
     C                   MOVEL     SKAC          DSCTYL
      *
     C     Z             OCCUR     DSADD
      * A/C for payment
     C                   MOVE      SAAFPN        DSAFPN
     C                   MOVE      SAAFPL        DSAFPL
      *                                                                                       CSW210
     C                   IF        CSW210 = 'Y'                                               CSW210
      * Debtor                                                                                CSW210
     C                   MOVE      SADIDN        DSDIDN                                       CSW210
     C                   MOVE      SADLIN        DSDLIN                                       CSW210
     C                   MOVE      SADAD1        DSDAD1                                       CSW210
     C                   MOVE      SADAD2        DSDAD2                                       CSW210
     C                   MOVE      SADAD3        DSDAD3                                       CSW210
     C                   MOVE      SADAD4        DSDAD4                                       CSW210
      * Place of Clearing                                                                     CSW210
     C                   MOVE      SAPCLR        DSPCLR                                       CSW210
      * Qualified Foreign Intermediary                                                        CSW210
     C                   MOVE      SAQFIN        DSQFIN                                       CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
      * A/C with institution
     C                   MOVE      SAAWIN        DSAWIN
     C                   MOVE      SAAWIL        DSAWIL
      * Benificiary of money
     C                   MOVE      SABOFN        DSBOFN
     C                   MOVE      SABOF1        DSBOF1
     C                   MOVE      SABOF2        DSBOF2
      * Sender to receiver info
     C                   MOVE      SASRL1        DSSRL1
     C                   MOVE      SASRL2        DSSRL2
     C                   MOVE      SASRL3        DSSRL3
      * Further information
     C                   MOVE      SAFIN1        DSFIN1
     C                   MOVE      SAFIN2        DSFIN2
      * Registration details
     C                   MOVE      SARED1        DSRED1
     C                   MOVE      SARED2        DSRED2
      * Narrative
     C                   MOVE      SANAS1        DSNAL1
     C                   MOVE      SANAS2        DSNAL2
      * Clearing correspondent
     C                   MOVE      SACCTN        DSCCTN
      * Counterparty Safekeeping                                                            BUG10087
     C                   MOVE      SADRS3        DSCTYN                                     BUG10087
     C                   MOVE      SADRS4        DSCTYL                                     BUG10087
      *
 B2  C                   SELECT
 X2  C     Z             WHENEQ    2
     C     Z             OREQ      4
     C     Z             OREQ      6
     C     Z             OREQ      8
      * Outgoing
      * Receiver of securities
 B3  C                   IF        CSW003 = 'Y' AND @REDE <> 'TP'
     C                   MOVE      SADRSN        DSRSSN
     C                   MOVE      SADRS1        DSRSS1
     C                   MOVE      SADRS2        DSRSS2
     C                   MOVE      SADRS3        DSRSS3
     C                   MOVE      SADRS4        DSRSS4
 E3  C                   ENDIF
      *
 X2  C     Z             WHENEQ    1
     C     Z             OREQ      3
     C     Z             OREQ      5
     C     Z             OREQ      7
      * Incoming
      * Deliver of securities
 B3  C                   IF        CSW003 = 'Y' AND @REDE = 'TP'
     C                   MOVE      SADRSN        DSDSSN
     C                   MOVE      SADRS1        DSDSS1
     C                   MOVE      SADRS2        DSDSS2
     C                   MOVE      SADRS3        DSDSS3
     C                   MOVE      SADRS4        DSDSS4
 E3  C                   ENDIF
      *
 E2  C                   ENDSL
      * Beneficiary of securities
     C                   MOVE      SABSSN        DSBSSN
     C                   MOVE      SABSS1        DSBSS1
     C                   MOVE      SABSS2        DSBSS2
      *
 B2  C     DSBSSN        IFEQ      *BLANKS
     C     DPMVType      ANDEQ     'WO'
     C                   MOVEL     DDDPBN        DSBSSN
 E2  C                   ENDIF
      *
     C                   MOVEL     SAIMD1        DSIMMD1
     C                   MOVEL     SAIMD2        DSIMMD2
     C**********         MOVEL     SAIMD3        DSIMMD3                                     CSW206D
     C**********         MOVEL     SAIMD4        DSIMMD4                                     CSW206D
     C**********         MOVEL     SAIMD5        DSIMMD5                                     CSW206D
     C**********         MOVEL     SAIMD6        DSIMMD6                                     CSW206D
     C**********         MOVEL     SAIMD7        DSIMMD7                                     CSW206D
     C**********         MOVEL     SAIMD8        DSIMMD8                                     CSW206D
     C**********         MOVEL     SAIMD9        DSIMMD9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     SAIMD3        DSIMMD3                                     CSW206E
     C                   MOVEL     SAIMD4        DSIMMD4                                     CSW206E
     C                   MOVEL     SAIMD5        DSIMMD5                                     CSW206E
     C                   MOVEL     SAIMD6        DSIMMD6                                     CSW206E
     C                   MOVEL     SAIMD7        DSIMMD7                                     CSW206E
     C                   MOVEL     SAIMD8        DSIMMD8                                     CSW206E
     C                   MOVEL     SAIMD9        DSIMMD9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     SAIMS1        DSIMSA1
     C                   MOVEL     SAIMS2        DSIMSA2
     C**********         MOVEL     SAIMS3        DSIMSA3                                     CSW206D
     C**********         MOVEL     SAIMS4        DSIMSA4                                     CSW206D
     C**********         MOVEL     SAIMS5        DSIMSA5                                     CSW206D
     C**********         MOVEL     SAIMS6        DSIMSA6                                     CSW206D
     C**********         MOVEL     SAIMS7        DSIMSA7                                     CSW206D
     C**********         MOVEL     SAIMS8        DSIMSA8                                     CSW206D
     C**********         MOVEL     SAIMS9        DSIMSA9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     SAIMS3        DSIMSA3                                     CSW206E
     C                   MOVEL     SAIMS4        DSIMSA4                                     CSW206E
     C                   MOVEL     SAIMS5        DSIMSA5                                     CSW206E
     C                   MOVEL     SAIMS6        DSIMSA6                                     CSW206E
     C                   MOVEL     SAIMS7        DSIMSA7                                     CSW206E
     C                   MOVEL     SAIMS8        DSIMSA8                                     CSW206E
     C                   MOVEL     SAIMS9        DSIMSA9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     SAPSET        DSPSET
     C                   MOVEL     SANAC1        DSNAC1
     C                   MOVEL     SANAC2        DSNAC2
 E1  C                   ENDIF
      *
      ** If CSE022 is installed then setup Safekeeping A/C Line
      ** by using module SEDORFRTV
      *
 B1  C     CSE022        IFEQ      'Y'
     C                   MOVEL     DDDPID        PDEPO
     C                   MOVE      DDDPID        DSSKAN                                     BUG10087
     C                   MOVEL     PCUST         PCUSTN
     C                   CALL      'SEDORFRTV'
     C                   PARM      *BLANKS       PRETC            10
     C                   PARM                    PDEPO             6
     C                   PARM                    PCUSTN            6
     C                   PARM                    PSKAL            20
      *
 B2  C     PSKAL         IFEQ      *BLANKS
     C                   MOVEL     @BICN         PCUSTN
     C                   CALL      'SEDORFRTV'
     C                   PARM      *BLANKS       PRETC
     C                   PARM                    PDEPO
     C                   PARM                    PCUSTN
     C                   PARM                    PSKAL
 E2  C                   ENDIF
      *
     C                   MOVEL     PSKAL         DSSKAL
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BlankOut - Blanks out non-displayed fields
      *****************************************************************
     C     BlankOut      BEGSR
      *
      ** Screen 1
      *
     C                   IF        CSW003 = 'Y' AND @CLAS = 'E'
     C                   EVAL      DSFCOD = *Blanks
     C                   ENDIF
      *
     C                   IF        CSW003 = 'Y' AND CSE028 <> 'Y' AND
     C                             @CLAS <> 'C' AND @CLAS <> 'E'
     C                   EVAL      DSINST = *Blanks
     C                   EVAL      DSINSS = *Blanks
     C                   EVAL      DSSAFA = *Blanks
     C                   EVAL      DSRPTY = *Blanks
     C                   EVAL      DSGDEL = *Blanks
     C                   EVAL      DSSROL = *Blanks
     C                   EVAL      DSFCOD = *Blanks
     C                   ENDIF
      *
     C                   IF        CSE029 <> 'Y'
     C                   EVAL      DSSTST = *Blanks
     C                   EVAL      DSTRRM = *Blanks
     C                   EVAL      DSCHID = *Blanks
     C                   ENDIF
      *
     C                   IF        CSW202 = 'Y'
     C                   EVAL      DSEUCL = *Blanks
     C                   ENDIF
      *
      ** Screen 2
      *
      ** Screen 2 Format 1
      *
     C**********         IF        CSW003 = 'Y' AND                                         AR586519
     C                   IF        CSW003 = 'Y' AND CSE028 <> 'Y' AND                       AR586519
     C                             (@CLAS = 'C' OR @CLAS = 'E')
     C                   EVAL      DSAFPN = *Blanks
     C                   EVAL      DSAFPL = *Blanks
     C                   ENDIF
      *                                                                                       CSW210
     C**********         IF        CSW210 = 'Y'                                      CSW210 AR578319
     C                   IF        CSW210 <> 'Y'                                            AR578319
     C                   EVAL      DSDIDN = *Blanks                                           CSW210
     C                   EVAL      DSDLIN = *Blanks                                           CSW210
     C                   EVAL      DSDAD1 = *Blanks                                           CSW210
     C                   EVAL      DSDAD2 = *Blanks                                           CSW210
     C                   EVAL      DSDAD3 = *Blanks                                           CSW210
     C                   EVAL      DSDAD4 = *Blanks                                           CSW210
     C                   ENDIF                                                                CSW210
      *
      ** Screen 2 Format 2
      *
     C                   IF        CSW098 <> 'Y'
     C                   EVAL      DSINVE = *Blanks
     C                   ENDIF
      *
     C                   IF        CSW003 = 'Y' AND CSE028 <> 'Y' AND
     C                             (@CLAS = 'C' OR @CLAS = 'E')
     C                   EVAL      DSSKAN = *Blanks
     C                   EVAL      DSSKAL = *Blanks
     C                   ENDIF
      *
     C                   IF        CSW003 = 'Y' AND @REDE = 'TP'
     C                   EVAL      DSRSSA = *Blanks
     C                   EVAL      DSRSSN = *Blanks
     C                   EVAL      DSRSS1 = *Blanks
     C                   EVAL      DSRSS2 = *Blanks
     C                   EVAL      DSRSS3 = *Blanks
     C                   EVAL      DSRSS4 = *Blanks
     C                   ENDIF
      *
     C                   IF        CSW003 = 'Y' AND @REDE <> 'TP'
     C                   EVAL      DSDCTL = *Blanks
     C                   EVAL      DSDSSA = *Blanks
     C                   EVAL      DSDSSN = *Blanks
     C                   EVAL      DSDSS1 = *Blanks
     C                   EVAL      DSDSS2 = *Blanks
     C                   EVAL      DSDSS3 = *Blanks
     C                   EVAL      DSDSS4 = *Blanks
     C                   ENDIF
      *
      ** Screen 2 Format 3
      *
     C                   IF        CSE028 <> 'Y'
     C                   EVAL      DSIMMD1 = *Blanks
     C                   EVAL      DSIMSA1 = *Blanks
     C                   EVAL      DSIMMD2 = *Blanks
     C                   EVAL      DSIMSA2 = *Blanks
     C**********         EVAL      DSIMMD3 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMSA3 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMMD4 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMSA4 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMMD5 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMSA5 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMMD6 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMSA6 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMMD7 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMSA7 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMMD8 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMSA8 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMMD9 = *Blanks                                         CSW206D
     C**********         EVAL      DSIMSA9 = *Blanks                                         CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   EVAL      DSIMMD3 = *Blanks                                         CSW206E
     C                   EVAL      DSIMSA3 = *Blanks                                         CSW206E
     C                   EVAL      DSIMMD4 = *Blanks                                         CSW206E
     C                   EVAL      DSIMSA4 = *Blanks                                         CSW206E
     C                   EVAL      DSIMMD5 = *Blanks                                         CSW206E
     C                   EVAL      DSIMSA5 = *Blanks                                         CSW206E
     C                   EVAL      DSIMMD6 = *Blanks                                         CSW206E
     C                   EVAL      DSIMSA6 = *Blanks                                         CSW206E
     C                   EVAL      DSIMMD7 = *Blanks                                         CSW206E
     C                   EVAL      DSIMSA7 = *Blanks                                         CSW206E
     C                   EVAL      DSIMMD8 = *Blanks                                         CSW206E
     C                   EVAL      DSIMSA8 = *Blanks                                         CSW206E
     C                   EVAL      DSIMMD9 = *Blanks                                         CSW206E
     C                   EVAL      DSIMSA9 = *Blanks                                         CSW206E
     C                   ENDIF                                                               CSW206E
     C                   EVAL      DSPSET  = *Blanks
     C                   EVAL      DSNAC1  = *Blanks
     C                   EVAL      DSNAC2  = *Blanks
     C                   ENDIF
      *
     C**********         IF        CSW210 = 'Y'                                      CSW210 AR578319
     C                   IF        CSW210 <> 'Y'                                            AR578319
     C                   EVAL      DSPCLR = *Blanks                                           CSW210
     C                   EVAL      DSQFIN = *Blanks                                           CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE1 - Convert a date into a day number
      *****************************************************************
     C     ZDATE1        BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE             6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
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
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeIn
      ** Depot movement type
     C                   PARM                    DPMVType          2
      ** Receive/Deliver type
     C                   PARM                    @REDE             2
      ** Branch internal customer number
     C                   PARM                    @BICN             6
      ** Security Customer classification
     C                   PARM                    @CLAS             1
      ** Security data:
      ** . Market center
      ** . Nominal currency
      ** . Investment type
     C                   PARM                    @SMCC             2
     C                   PARM                    @NMCY             3
     C                   PARM                    @SITP             3
      ** Midas Run Date number & Date format
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
      ** Features status
     C                   PARM                    CSE022            1
     C                   PARM                    CSE028            1
     C                   PARM                    CSE029            1
     C                   PARM                    CSW003            1
     C                   PARM                    CSW098            1
     C                   PARM                    CSW202            1
     C                   PARM                    CSW206            1                         CSW206E
     C                   PARM                    CSW210            1                          CSW210
      *
      ** INPUT/OUTPUT PARAMETERS:
      ** Transaction Details in screen format
     C                   PARM                    WCPTY             6
     C                   PARM                    DPMVScrFld
      *
      ** OUTPUT PARAMETERS:
      ** Additional screen fields (destination of settlement)
     C                   PARM                    DDROUS            6
     C                   PARM                    DDROTS           12
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
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
