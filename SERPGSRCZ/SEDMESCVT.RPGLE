     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV WI/WO Extended Settlement - Convert')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEDMESCVT - Depot Movement WI/WO extension & extended  *
      *                    settlement - File to Screen Conversion     *
      *                                                               *
      *  Function:  This module converts the fields of a Depot        *
      *             Movement Extension and Extended Settlement        *
      *             from file to screen.                              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210             Date 04May10               *
      *                 BUG28003           Date 12Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CAP087             Date 03Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 222727             Date 05Nov03               *
      *                 CSE045   *CREATE   Date 06Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  BUG28003 - Value for 'Beneficiary Securities (Customer)' and *
      *             'Counterparty Safekeeping A/c' was reset after    *
      *             Authorization                                     *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           (recompile due to change in SEDMWIPD)               *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
     D SEDMX1        E DS                  EXTNAME(DPTMVDX1)
      ** Extension File in file format
 
     D SEDMX2        E DS                  EXTNAME(DPTMVDX2)
      ** Extended Settlement File in file format
 
     D DPMVFld       E DS                  EXTNAME(SEDMWIPD)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for access programs
 
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
      *
      ** Set screen fields
      *
     C                   EXSR      SCREEN
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
      *
      ** Screen 1
      *
     C                   MOVE      DPGMES        DSGMES
     C                   MOVE      DPINST        DSINST
     C                   MOVE      DPINSS        DSINSS
     C                   MOVE      DPEUCL        DSEUCL
     C                   MOVE      DPSAFA        DSSAFA
     C                   MOVE      DPRPTY        DSRPTY
     C                   MOVE      DPFIND        DSFIND
     C                   MOVE      DPGMEC        DSGMEC
     C                   MOVE      DPTRTT        DSTRTT
     C                   MOVE      DPGDEL        DSGDEL
     C                   MOVE      DPFCOD        DSFCOD
     C                   MOVE      DPSROL        DSSROL
     C                   MOVE      DPNEW         DS1522
     C                   MOVE      DPSTMP        DSSTST
     C                   MOVE      DPCHID        DSCHID
     C                   MOVE      DPTRRM        DSTRRM
      *
      ** Screen 2
      ** -- Format 1
      *
     C                   MOVE      D2AFPN        DSAFPN
     C                   MOVE      D2AFPL        DSAFPL
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   MOVE      D2DIDN        DSDIDN                                       CSW210
     C                   MOVE      D2DLIN        DSDLIN                                       CSW210
     C                   MOVE      D2DAD1        DSDAD1                                       CSW210
     C                   MOVE      D2DAD2        DSDAD2                                       CSW210
     C                   MOVE      D2DAD3        DSDAD3                                       CSW210
     C                   MOVE      D2DAD4        DSDAD4                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   MOVE      D2AWIA        DSAWIA
     C                   MOVE      D2AWIN        DSAWIN
     C                   MOVE      D2AWIL        DSAWIL
     C                   MOVE      D2BOFA        DSBOFA
     C                   MOVE      D2BOFN        DSBOFN
     C                   MOVE      D2BOF1        DSBOF1
     C                   MOVE      D2BOF2        DSBOF2
     C                   MOVE      D2SRL1        DSSRL1
     C                   MOVE      D2SRL2        DSSRL2
     C                   MOVE      D2SRL3        DSSRL3
     C                   MOVE      D2FIN1        DSFIN1
     C                   MOVE      D2FIN2        DSFIN2
     C                   MOVE      D2RED1        DSRED1
     C                   MOVE      D2RED2        DSRED2
     C                   MOVE      D2NAL1        DSNAL1
     C                   MOVE      D2NAL2        DSNAL2
      *
      ** -- Format 2
      *
     C**********         IF        CSE028 = 'Y' AND DS1522 = 'Y' AND                        BUG28003
     C**********                   DSGMES = 'Y'                                             BUG28003
     C                   MOVE      D2CTYN        DSCTYN
     C                   MOVE      D2CTYL        DSCTYL
     C**********         ENDIF                                                              BUG28003
      *
     C                   MOVE      D2IPYN        DSIPYN
     C                   MOVE      D2IPYL        DSIPYL
     C                   MOVE      D2INVE        DSINVE
     C                   MOVE      D2SKAN        DSSKAN
     C                   MOVE      D2SKAL        DSSKAL
     C                   MOVE      D2CCTN        DSCCTN
     C                   MOVE      D2DCTL        DSDCTL
     C                   MOVE      D2RSSA        DSRSSA
     C                   MOVE      D2RSSN        DSRSSN
     C                   MOVE      D2RSS1        DSRSS1
     C                   MOVE      D2RSS2        DSRSS2
     C                   MOVE      D2RSS3        DSRSS3
     C                   MOVE      D2RSS4        DSRSS4
     C                   MOVE      D2DSSA        DSDSSA
     C                   MOVE      D2DSSN        DSDSSN
     C                   MOVE      D2DSS1        DSDSS1
     C                   MOVE      D2DSS2        DSDSS2
     C                   MOVE      D2DSS3        DSDSS3
     C                   MOVE      D2DSS4        DSDSS4
     C                   MOVE      D2BSSA        DSBSSA
     C                   MOVE      D2BSSN        DSBSSN
     C                   MOVE      D2BSS1        DSBSS1
     C                   MOVE      D2BSS2        DSBSS2
      *
      ** -- Format 3
      *
     C     CSE028        IFEQ      'Y'
     C                   MOVEL     D2IMD1        DSIMMD1
     C                   MOVEL     D2IMS1        DSIMSA1
     C                   MOVEL     D2IMD2        DSIMMD2
     C                   MOVEL     D2IMS2        DSIMSA2
     C**********         MOVEL     D2IMD3        DSIMMD3                                     CSW206D
     C**********         MOVEL     D2IMS3        DSIMSA3                                     CSW206D
     C**********         MOVEL     D2IMD4        DSIMMD4                                     CSW206D
     C**********         MOVEL     D2IMS4        DSIMSA4                                     CSW206D
     C**********         MOVEL     D2IMD5        DSIMMD5                                     CSW206D
     C**********         MOVEL     D2IMS5        DSIMSA5                                     CSW206D
     C**********         MOVEL     D2IMD6        DSIMMD6                                     CSW206D
     C**********         MOVEL     D2IMS6        DSIMSA6                                     CSW206D
     C**********         MOVEL     D2IMD7        DSIMMD7                                     CSW206D
     C**********         MOVEL     D2IMS7        DSIMSA7                                     CSW206D
     C**********         MOVEL     D2IMD8        DSIMMD8                                     CSW206D
     C**********         MOVEL     D2IMS8        DSIMSA8                                     CSW206D
     C**********         MOVEL     D2IMD9        DSIMMD9                                     CSW206D
     C**********         MOVEL     D2IMS9        DSIMSA9                                     CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVEL     D2IMD3        DSIMMD3                                     CSW206E
     C                   MOVEL     D2IMS3        DSIMSA3                                     CSW206E
     C                   MOVEL     D2IMD4        DSIMMD4                                     CSW206E
     C                   MOVEL     D2IMS4        DSIMSA4                                     CSW206E
     C                   MOVEL     D2IMD5        DSIMMD5                                     CSW206E
     C                   MOVEL     D2IMS5        DSIMSA5                                     CSW206E
     C                   MOVEL     D2IMD6        DSIMMD6                                     CSW206E
     C                   MOVEL     D2IMS6        DSIMSA6                                     CSW206E
     C                   MOVEL     D2IMD7        DSIMMD7                                     CSW206E
     C                   MOVEL     D2IMS7        DSIMSA7                                     CSW206E
     C                   MOVEL     D2IMD8        DSIMMD8                                     CSW206E
     C                   MOVEL     D2IMS8        DSIMSA8                                     CSW206E
     C                   MOVEL     D2IMD9        DSIMMD9                                     CSW206E
     C                   MOVEL     D2IMS9        DSIMSA9                                     CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVEL     D2PSET        DSPSET
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   MOVEL     D2PCLR        DSPCLR                                       CSW210
     C                   MOVEL     D2QFIN        DSQFIN                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   MOVEL     D2NAC1        DSNAC1
     C                   MOVEL     D2NAC2        DSNAC2
     C                   ENDIF
      *
      ** In Enquiry mode, retrieve customer shortnames
      *
 B1  C     DDACTN        IFEQ      'E'
      *
 B2  C     DSAFPN        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSAFPN        WKEY1            10
     C                   PARM      *Blanks       WKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSAFPN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C     DSAWIN        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSAWIN        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSAWIN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C     DSBOFN        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSBOFN        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSBOFN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C                   IF        DSIPYN <> *Blanks AND
     C                             DSIPYN <> '000000    '
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSIPYN        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSIPYN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C     DSCTYN        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSCTYN        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSCTYN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C     DSINVE        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSINVE        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSINVE
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C     DSSKAN        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSSKAN        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSSKAN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C     DSRSSN        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSRSSN        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSRSSN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C     DSDSSN        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSDSSN        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSDSSN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 B2  C     DSBSSN        IFNE      *Blanks
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*DBERR '     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      DSBSSN        WKEY1
     C                   PARM      *Blanks       WKYST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
 B3  C     @RtCd         IFEQ      *Blanks
     C                   MOVE      BBCSSN        DSBSSN
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Extension and Extended Settlements Details
     C                   PARM                    SEDMX1
     C                   PARM                    SEDMX2
      ** Features status
     C                   PARM                    CSE028            1
      ** CSW206 Features status                                                              CSW206E
     C                   PARM                    CSW206            1                         CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210            1                          CSW210
      *
      ** INPUT/OUTPUT PARAMETERS
      ** Fields in screen format (whole API message)
     C                   PARM                    DPMVFld
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
(c) Finastra International Limited 2003
