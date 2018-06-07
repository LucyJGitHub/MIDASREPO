     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*: OVRDBF FILE(SDCBRTLR) TOFILE(SDCBRTL0) SHARE(*NO)          : *
/*XBIB*: OVRDBF FILE(PTYHSTPR) TOFILE(PTYHSTPD) SHARE(*NO)          : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details New Parties Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module.                             *
      *                                                               *
      *  SDCUSD7VL - Customer New Participants Validation            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD040876           Date 13Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD007             Date 28Aug00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 27Jun99               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE007 - Base Rate Tax 2001                                  *
      *  CSD007 - Customer Closing: Recompile.                        *
      *  CDL008 - Continous Linked Settlement (Recompiled)            *
      *  CAP034 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **
     FSDCBRTLR  IF   E           K DISK
     FINTPSL8   IF   E           K DISK    RENAME(INTPSDDF:INTPSLF8)
     F                                     PREFIX(C_)
     FPTYHSTPR  IF   E           K DISK
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUDTV001
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      * New Customer in File Format
     D CuFilFmt      E DS                  EXTNAME(SDVCUSDPD)
 
      ** Customer Base Rate Tax in screen format
     D CuBrt         E DS                  EXTNAME(SDCUBRPD)
 
      ** Customer Base Rate Tax OK indicators
     D OKCuBrt       E DS                  EXTNAME(SDECUBRPD)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for run date and Multibranch Indicator using rundat.
     D RUNDAT          DS
     D  RDNB                   8     10P 0
 
     D BrtFilFmt     E DS                  EXTNAME(SDVCUBRPD)
      * Valid Customer Base Rate Tax File
 
     D ChgNamArr       S              1    DIM(5)
      ** Changed Party Names Array
 
     D LFLG            S              1    DIM(10)
      ** Liable Flag Array
 
     D EFLD            S              5S 0 DIM(10)
      ** Effective Date Array
 
     D EFLDA           S              5    DIM(10)
      ** Effective Date Array Alpha
 
     D LCHD            S              5S 0 DIM(10)
      ** Liable Change Date Array
 
     D LCHDA           S              5    DIM(10)
      ** Liable Change Date Array
 
     D                 DS
     D CuBrtScrn               1    704
     D DETAI1                  9    147
     D DETAI2                148    286
     D DETAI3                287    425
     D DETAI4                426    564
     D DETAI5                565    703
     D SS1TTL                  9     12
     D SS1NAM                 13     35
     D SS1INI                 36     38
     D SS1AD1                 39     66
     D SS1AD2                 67     94
     D SS1AD3                 95    122
     D SS1PC1                123    126
     D SS1PC2                127    129
     D SS1BRT                130    130
     D SS1NIN                131    139
     D SS1DOB                140    145
     D SS1SQN                146    147
     D SS2TTL                148    151
     D SS2NAM                152    174
     D SS2INI                175    177
     D SS2AD1                178    205
     D SS2AD2                206    233
     D SS2AD3                234    261
     D SS2PC1                262    265
     D SS2PC2                266    268
     D SS2BRT                269    269
     D SS2NIN                270    278
     D SS2DOB                279    284
     D SS2SQN                285    286
     D SS3TTL                287    290
     D SS3NAM                291    313
     D SS3INI                314    316
     D SS3AD1                317    344
     D SS3AD2                345    372
     D SS3AD3                373    400
     D SS3PC1                401    404
     D SS3PC2                405    407
     D SS3BRT                408    408
     D SS3NIN                409    417
     D SS3DOB                418    423
     D SS3SQN                424    425
     D SS4TTL                426    429
     D SS4NAM                430    452
     D SS4INI                453    455
     D SS4AD1                456    483
     D SS4AD2                484    511
     D SS4AD3                512    539
     D SS4PC1                540    543
     D SS4PC2                544    546
     D SS4BRT                547    547
     D SS4NIN                548    556
     D SS4DOB                557    562
     D SS4SQN                563    564
     D SS5TTL                565    568
     D SS5NAM                569    591
     D SS5INI                592    594
     D SS5AD1                595    622
     D SS5AD2                623    650
     D SS5AD3                651    678
     D SS5PC1                679    682
     D SS5PC2                683    685
     D SS5BRT                686    686
     D SS5NIN                687    695
     D SS5DOB                696    701
     D SS5SQN                702    703
     D SSTXIN                704    704
      *
     D CuBrtMast     E DS                  EXTNAME(SDCBRTPD)
      *
     D                 DS
     D CuBrtFile               1    716
     D DET1                    9    147
     D DET2                  148    286
     D DET3                  287    425
     D DET4                  426    564
     D DET5                  565    703
     D OLDBR1                130    130
     D OLDBR2                269    269
     D OLDBR3                408    408
     D OLDBR4                547    547
     D OLDBR5                686    686
 
     D                 DS
     D PP1DET                  1    139
     D PT1TTL                  1      4
     D PT1NME                  5     27
     D PT1INT                 28     30
     D PT1AD1                 31     58
     D PT1AD2                 59     86
     D PT1AD3                 87    114
     D PT1PC1                115    118
     D PT1PC2                119    121
     D NEWBR1                122    122
     D PT1NIN                123    131
     D NEWDB1                132    137
     D NEWSQ1                138    139
     D PP2DET                140    278
     D PT2TTL                140    143
     D PT2NME                144    166
     D PT2INT                167    169
     D PT2AD1                170    197
     D PT2AD2                198    225
     D PT2AD3                226    253
     D PT2PC1                254    257
     D PT2PC2                258    260
     D NEWBR2                261    261
     D PT2NIN                262    270
     D NEWDB2                271    276
     D NEWSQ2                277    278
     D PP3DET                279    417
     D PT3TTL                279    282
     D PT3NME                283    305
     D PT3INT                306    308
     D PT3AD1                309    336
     D PT3AD2                337    364
     D PT3AD3                365    392
     D PT3PC1                393    396
     D PT3PC2                397    399
     D NEWBR3                400    400
     D PT3NIN                401    409
     D NEWDB3                410    415
     D NEWSQ3                416    417
     D PP4DET                418    556
     D PT4TTL                418    421
     D PT4NME                422    444
     D PT4INT                445    447
     D PT4AD1                448    475
     D PT4AD2                476    503
     D PT4AD3                504    531
     D PT4PC1                532    535
     D PT4PC2                536    538
     D NEWBR4                539    539
     D PT4NIN                540    548
     D NEWDB4                549    554
     D NEWSQ4                555    556
     D PP5DET                557    695
     D PT5TTL                557    560
     D PT5NME                561    583
     D PT5INT                584    586
     D PT5AD1                587    614
     D PT5AD2                615    642
     D PT5AD3                643    670
     D PT5PC1                671    674
     D PT5PC2                675    677
     D NEWBR5                678    678
     D PT5NIN                679    687
     D NEWDB5                688    693
     D NEWSQ5                694    695
 
 
     D                 DS
     D TDATE                   1      6
     D TDAY                    1      2
     D TMONTH                  3      4
     D TYEAR                   5      6
 
     D                 DS
     D  DATE                   1      6
     D  DAY                    1      2  0
     D  MONTH                  3      4  0
     D  YEAR                   5      6  0
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUDTV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SDCUDTV003
 
      ** Initial Routine
      *
      /COPY WNCPYSRC,SDCUDTV004
     C                   EXSR      INITIAL
      /COPY WNCPYSRC,SDCUDTV005
      *
 
      ** Validate New Participant Prompt
      *
      /COPY WNCPYSRC,SDCUDTV006
     C                   EXSR      VCNPPT
      /COPY WNCPYSRC,SDCUDTV007
      *
      *
      ** Process BRT data
      *
      /COPY WNCPYSRC,SDCUDTV008
     C                   EXSR      VCHISP
      /COPY WNCPYSRC,SDCUDTV009
      *
     C                   RETURN
      *
      *
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUDTV012
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate New Participant Prompt
      *****************************************************************
     C     VCNPPT        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate New Participant Prompt
      *
     C                   CALLB     'SDVPASS01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      * Base Rate Tax details
     C                   PARM                    CuBrt
      *
      * Change Name Array
     C                   PARM                    ChgNamArr
      *
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Participant 1 Status OK
      ** Participant 2 Status OK
      ** Participant 3 Status OK
      ** Participant 4 Status OK
      ** Participant 5 Status OK
     C                   PARM                    DD1STSOK          1
     C                   PARM                    DD2STSOK          1
     C                   PARM                    DD3STSOK          1
     C                   PARM                    DD4STSOK          1
     C                   PARM                    DD5STSOK          1
 
      * Update error info with that returned from validation
 
     C                   EXSR      UPDATERRS
 
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Populate DS Parameter Fields for Base Rate Tax
      *****************************************************************
     C     VCHISP        BEGSR
 
      ** If there are no errors
 
     C     Idx           IFEQ      0
 
     C* INITIALIZE SDCBRTPD DETAILS
     C*
     C                   MOVEL     *BLANK        PP1DET
     C                   MOVEL     *BLANK        PP2DET
     C                   MOVEL     *BLANK        PP3DET
     C                   MOVEL     *BLANK        PP4DET
     C                   MOVEL     *BLANK        PP5DET
     C                   MOVEL     *BLANK        PTAXIN            1
 
      **SET*UP*SDCBRTPD*DETAILS*IF*A/C*HOLDER*TYPE*IS*'I'*OR*'J'***                           CRE007
      * SET UP SDCBRTPD DETAILS IF A/C HOLDER TYPE IS 'I','J' or 'R'                          CRE007
 
     C     DDAHLT        IFEQ      'I'
     C     DDAHLT        OREQ      'J'
     C     DDAHLT        OREQ      'R'                                                        CRE007
     C                   MOVE      DETAI1        PP1DET
     C                   MOVE      DETAI2        PP2DET
     C                   MOVE      DETAI3        PP3DET
     C                   MOVE      DETAI4        PP4DET
     C                   MOVE      DETAI5        PP5DET
     C                   ENDIF
 
      ** Chain to BRT file using entry parameters
 
     C                   MOVE      DDCUSN        XCNUM
     C     XCNUM         CHAIN     SDCBRTD0                           99
     C     *IN99         IFEQ      *OFF
     C                   MOVE      BR1SQN        NEWSQ1
     C                   MOVE      BR2SQN        NEWSQ2
     C                   MOVE      BR3SQN        NEWSQ3
     C                   MOVE      BR4SQN        NEWSQ4
     C                   MOVE      BR5SQN        NEWSQ5
      *
      ** Count the number of parties
      *
     C                   Z-ADD     0             OLDNOP            1 0
     C     H1BRTL        IFNE      ' '
     C                   ADD       1             OLDNOP
     C                   ENDIF
     C     H2BRTL        IFNE      ' '
     C                   ADD       1             OLDNOP
     C                   ENDIF
     C     H3BRTL        IFNE      ' '
     C                   ADD       1             OLDNOP
     C                   ENDIF
     C     H4BRTL        IFNE      ' '
     C                   ADD       1             OLDNOP
     C                   ENDIF
     C     H5BRTL        IFNE      ' '
     C                   ADD       1             OLDNOP
     C                   ENDIF
      *
     C                   ENDIF
 
     C     DDACTN        IFEQ      'D'
     C                   MOVE      'C'           BRRECI
     C                   ELSE
     C                   MOVE      'D'           BRRECI
     C                   ENDIF
     C                   MOVE      BJRDNB        BRXLCD
     C                   MOVE      DDACTN        BRCHTP
 
      ** Action Code - Amend
 
     C     DDACTN        IFEQ      'A'
     C     DDAHLT        IFEQ      'I'
     C     DDAHLT        OREQ      'J'
     C     DDAHLT        OREQ      'R'                                                        CRE007
 
      ** Store next available sequence number
 
     C                   Z-ADD     0             NEWNOP            1 0
 
      ** If party status is not blank, process party data
 
     C     DD1STS        IFNE      *BLANKS
     C     CHGNAMARR(1)  OREQ      'Y'
     C                   MOVE      PT1TTL        BR1TIT
     C                   MOVE      PT1NME        BR1NAM
     C                   MOVE      PT1INT        BR1INI
     C                   MOVE      PT1AD1        BR1AD1
     C                   MOVE      PT1AD2        BR1AD2
     C                   MOVE      PT1AD3        BR1AD3
     C                   MOVE      PT1PC1        BR1PC1
     C                   MOVE      PT1PC2        BR1PC2
     C                   MOVE      PT1NIN        BR1NIN
     C                   MOVE      NEWDB1        BR1DOB
     C     DD1STS        IFEQ      'Y'
     C     CHGNAMARR(1)  OREQ      'Y'
     C                   MOVE      NXASQN        BR1SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C                   ENDIF
 
     C     DD2STS        IFNE      *BLANKS
     C     CHGNAMARR(2)  OREQ      'Y'
     C                   MOVE      PT2TTL        BR2TIT
     C                   MOVE      PT2NME        BR2NAM
     C                   MOVE      PT2INT        BR2INI
     C                   MOVE      PT2AD1        BR2AD1
     C                   MOVE      PT2AD2        BR2AD2
     C                   MOVE      PT2AD3        BR2AD3
     C                   MOVE      PT2PC1        BR2PC1
     C                   MOVE      PT2PC2        BR2PC2
     C                   MOVE      PT2NIN        BR2NIN
     C                   MOVE      NEWDB2        BR2DOB
     C     DD2STS        IFEQ      'Y'
     C     CHGNAMARR(2)  OREQ      'Y'
     C                   MOVE      NXASQN        BR2SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C                   ENDIF
 
     C     DD3STS        IFNE      *BLANKS
     C     CHGNAMARR(3)  OREQ      'Y'
     C                   MOVE      PT3TTL        BR3TIT
     C                   MOVE      PT3NME        BR3NAM
     C                   MOVE      PT3INT        BR3INI
     C                   MOVE      PT3AD1        BR3AD1
     C                   MOVE      PT3AD2        BR3AD2
     C                   MOVE      PT3AD3        BR3AD3
     C                   MOVE      PT3PC1        BR3PC1
     C                   MOVE      PT3PC2        BR3PC2
     C                   MOVE      PT3NIN        BR3NIN
     C                   MOVE      NEWDB3        BR3DOB
     C     DD3STS        IFEQ      'Y'
     C     CHGNAMARR(3)  OREQ      'Y'
     C                   MOVE      NXASQN        BR3SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C                   ENDIF
 
     C     DD4STS        IFNE      *BLANKS
     C     CHGNAMARR(4)  OREQ      'Y'
     C                   MOVE      PT4TTL        BR4TIT
     C                   MOVE      PT4NME        BR4NAM
     C                   MOVE      PT4INT        BR4INI
     C                   MOVE      PT4AD1        BR4AD1
     C                   MOVE      PT4AD2        BR4AD2
     C                   MOVE      PT4AD3        BR4AD3
     C                   MOVE      PT4PC1        BR4PC1
     C                   MOVE      PT4PC2        BR4PC2
     C                   MOVE      PT4NIN        BR4NIN
     C                   MOVE      NEWDB4        BR4DOB
     C     DD4STS        IFEQ      'Y'
     C     CHGNAMARR(4)  OREQ      'Y'
     C                   MOVE      NXASQN        BR4SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C                   ENDIF
 
     C     DD5STS        IFNE      *BLANKS
     C     CHGNAMARR(5)  OREQ      'Y'
     C                   MOVE      PT5TTL        BR5TIT
     C                   MOVE      PT5NME        BR5NAM
     C                   MOVE      PT5INT        BR5INI
     C                   MOVE      PT5AD1        BR5AD1
     C                   MOVE      PT5AD2        BR5AD2
     C                   MOVE      PT5AD3        BR5AD3
     C                   MOVE      PT5PC1        BR5PC1
     C                   MOVE      PT5PC2        BR5PC2
     C                   MOVE      PT5NIN        BR5NIN
     C                   MOVE      NEWDB5        BR5DOB
     C     DD5STS        IFEQ      'Y'
     C     CHGNAMARR(5)  OREQ      'Y'
     C                   MOVE      NXASQN        BR5SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDIF
 
      ** Action Code - Insert
 
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     1             NXASQN
     C                   MOVEA     *BLANKS       LFLG
     C                   Z-ADD     *ZEROS        EFLD
     C                   Z-ADD     *ZEROS        LCHD
     C                   MOVE      BJRDNB        BRXLCD
     C                   MOVE      DDACTN        BRCHTP
     C                   MOVE      DDCUSN        BRCNUM
     C
     C     PP1DET        IFNE      *BLANKS
     C                   MOVE      PT1TTL        BR1TIT
     C                   MOVE      PT1NME        BR1NAM
     C                   MOVE      PT1INT        BR1INI
     C                   MOVE      PT1AD1        BR1AD1
     C                   MOVE      PT1AD2        BR1AD2
     C                   MOVE      PT1AD3        BR1AD3
     C                   MOVE      PT1PC1        BR1PC1
     C                   MOVE      PT1PC2        BR1PC2
     C                   MOVE      PT1NIN        BR1NIN
     C                   MOVE      NEWDB1        BR1DOB
     C                   MOVE      NXASQN        BR1SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C
     C     PP2DET        IFNE      *BLANKS
     C                   MOVE      PT2TTL        BR2TIT
     C                   MOVE      PT2NME        BR2NAM
     C                   MOVE      PT2INT        BR2INI
     C                   MOVE      PT2AD1        BR2AD1
     C                   MOVE      PT2AD2        BR2AD2
     C                   MOVE      PT2AD3        BR2AD3
     C                   MOVE      PT2PC1        BR2PC1
     C                   MOVE      PT2PC2        BR2PC2
     C                   MOVE      PT2NIN        BR2NIN
     C                   MOVE      NEWDB2        BR2DOB
     C                   MOVE      NXASQN        BR2SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C
     C     PP3DET        IFNE      *BLANKS
     C                   MOVE      PT3TTL        BR3TIT
     C                   MOVE      PT3NME        BR3NAM
     C                   MOVE      PT3INT        BR3INI
     C                   MOVE      PT3AD1        BR3AD1
     C                   MOVE      PT3AD2        BR3AD2
     C                   MOVE      PT3AD3        BR3AD3
     C                   MOVE      PT3PC1        BR3PC1
     C                   MOVE      PT3PC2        BR3PC2
     C                   MOVE      PT3NIN        BR3NIN
     C                   MOVE      NEWDB3        BR3DOB
     C                   MOVE      NXASQN        BR3SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C
     C     PP4DET        IFNE      *BLANKS
     C                   MOVE      PT4TTL        BR4TIT
     C                   MOVE      PT4NME        BR4NAM
     C                   MOVE      PT4INT        BR4INI
     C                   MOVE      PT4AD1        BR4AD1
     C                   MOVE      PT4AD2        BR4AD2
     C                   MOVE      PT4AD3        BR4AD3
     C                   MOVE      PT4PC1        BR4PC1
     C                   MOVE      PT4PC2        BR4PC2
     C                   MOVE      PT4NIN        BR4NIN
     C                   MOVE      NEWDB4        BR4DOB
     C                   MOVE      NXASQN        BR4SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C
     C     PP5DET        IFNE      *BLANKS
     C                   MOVE      PT5TTL        BR5TIT
     C                   MOVE      PT5NME        BR5NAM
     C                   MOVE      PT5INT        BR5INI
     C                   MOVE      PT5AD1        BR5AD1
     C                   MOVE      PT5AD2        BR5AD2
     C                   MOVE      PT5AD3        BR5AD3
     C                   MOVE      PT5PC1        BR5PC1
     C                   MOVE      PT5PC2        BR5PC2
     C                   MOVE      PT5NIN        BR5NIN
     C                   MOVE      NEWDB5        BR5DOB
     C                   MOVE      NXASQN        BR5SQN
     C                   ADD       1             NXASQN
     C                   ENDIF
     C
     C                   ENDIF
 
     C** Action Code - Insert or Amend
     C
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C
      * Set up output fields for BRT valid file
     C
     C                   MOVE      DDCUSN        BRCNUM
     C                   MOVE      DDAHLT        BRAHLT
     C                   MOVE      DDTXIN        BRTXIN
     C                   MOVE      DDPSTR        BRPSTR                                       CRE007
     C                   Z-ADD     NXASQN        BRNASQ
 
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     0             BRAHCD
     C                   ELSE
     C     DD1STS        IFEQ      'Y'
     C     DD2STS        OREQ      'Y'
     C     DD3STS        OREQ      'Y'
     C     DD4STS        OREQ      'Y'
     C     DD5STS        OREQ      'Y'
     C                   Z-ADD     BJRDNB        BRAHCD
     C                   ELSE
     C     OLDNOP        IFNE      NEWNOP
     C                   Z-ADD     BJRDNB        BRAHCD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     DDAHLT        IFNE      'I'
     C     DDAHLT        ANDNE     'J'
     C     DDAHLT        ANDNE     'R'                                                        CRE007
     C                   EVAL      DD1NAM=*BLANKS
     C                   EVAL      DD2NAM=*BLANKS
     C                   EVAL      DD3NAM=*BLANKS
     C                   EVAL      DD4NAM=*BLANKS
     C                   EVAL      DD5NAM=*BLANKS
 
      ** If A/C holder type is now B, C, N or O, set taxable indicator
     C     DDAHLT        IFEQ      'B'
     C     DDAHLT        OREQ      'C'
     C                   MOVEL     'N'           BRTXIN
     C                   ELSE
     C     DDAHLT        IFEQ      'N'
     C     DDAHLT        OREQ      'O'
     C                   MOVEL     'X'           BRTXIN
     C                   ENDIF
     C                   ENDIF
     C
     C                   MOVE      *BLANK        BRPSTR                                       CRE007
     C                   ENDIF
 
      ** Update participant fields
     C     DD1NAM        IFEQ      *BLANK
     C                   MOVE      *BLANK        BR1TIT
     C                   MOVE      *BLANK        BR1NAM
     C                   MOVE      *BLANK        BR1INI
     C                   MOVE      *BLANK        BR1AD1
     C                   MOVE      *BLANK        BR1AD2
     C                   MOVE      *BLANK        BR1AD3
     C                   MOVE      *BLANK        BR1PC1
     C                   MOVE      *BLANK        BR1PC2
     C                   MOVE      *BLANK        BR1BRL
     C                   MOVE      *BLANK        BR1NIN
     C                   MOVE      *ZEROS        BR1DOB
     C                   MOVE      *ZEROS        BR1SQN
     C                   ENDIF
 
     C     DD2NAM        IFEQ      *BLANK
     C                   MOVE      *BLANK        BR2TIT
     C                   MOVE      *BLANK        BR2NAM
     C                   MOVE      *BLANK        BR2INI
     C                   MOVE      *BLANK        BR2AD1
     C                   MOVE      *BLANK        BR2AD2
     C                   MOVE      *BLANK        BR2AD3
     C                   MOVE      *BLANK        BR2PC1
     C                   MOVE      *BLANK        BR2PC2
     C                   MOVE      *BLANK        BR2BRL
     C                   MOVE      *BLANK        BR2NIN
     C                   MOVE      *ZEROS        BR2DOB
     C                   MOVE      *ZEROS        BR2SQN
     C                   ENDIF
 
     C     DD3NAM        IFEQ      *BLANK
     C                   MOVE      *BLANK        BR3TIT
     C                   MOVE      *BLANK        BR3NAM
     C                   MOVE      *BLANK        BR3INI
     C                   MOVE      *BLANK        BR3AD1
     C                   MOVE      *BLANK        BR3AD2
     C                   MOVE      *BLANK        BR3AD3
     C                   MOVE      *BLANK        BR3PC1
     C                   MOVE      *BLANK        BR3PC2
     C                   MOVE      *BLANK        BR3BRL
     C                   MOVE      *BLANK        BR3NIN
     C                   MOVE      *ZEROS        BR3DOB
     C                   MOVE      *ZEROS        BR3SQN
     C                   ENDIF
 
     C     DD4NAM        IFEQ      *BLANK
     C                   MOVE      *BLANK        BR4TIT
     C                   MOVE      *BLANK        BR4NAM
     C                   MOVE      *BLANK        BR4INI
     C                   MOVE      *BLANK        BR4AD1
     C                   MOVE      *BLANK        BR4AD2
     C                   MOVE      *BLANK        BR4AD3
     C                   MOVE      *BLANK        BR4PC1
     C                   MOVE      *BLANK        BR4PC2
     C                   MOVE      *BLANK        BR4BRL
     C                   MOVE      *BLANK        BR4NIN
     C                   MOVE      *ZEROS        BR4DOB
     C                   MOVE      *ZEROS        BR4SQN
     C                   ENDIF
 
     C     DD5NAM        IFEQ      *BLANK
     C                   MOVE      *BLANK        BR5TIT
     C                   MOVE      *BLANK        BR5NAM
     C                   MOVE      *BLANK        BR5INI
     C                   MOVE      *BLANK        BR5AD1
     C                   MOVE      *BLANK        BR5AD2
     C                   MOVE      *BLANK        BR5AD3
     C                   MOVE      *BLANK        BR5PC1
     C                   MOVE      *BLANK        BR5PC2
     C                   MOVE      *BLANK        BR5BRL
     C                   MOVE      *BLANK        BR5NIN
     C                   MOVE      *ZEROS        BR5DOB
     C                   MOVE      *ZEROS        BR5SQN
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL
      *****************************************************************
     C     INITIAL       BEGSR
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C**   ROUTINE TO CALCULATE DAY NUMBER OF APRIL 6TH FOR CURRENT TAX YEAR
     C**
     C                   MOVE      '0'           *IN98
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEB        DATE
     C**
     C     MONTH         IFLT      4
     C     MONTH         OREQ      4
     C     DAY           ANDLT     6
     C                   SUB       1             YEAR
     C                   END
     C**
     C                   MOVE      '06'          TDAY
     C                   MOVE      '04'          TMONTH
     C                   MOVE      YEAR          TYEAR
     C**
     C                   MOVE      TDATE         ZDATEA
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        APR6CY            5 0
     C*
     C     BJDFIN        COMP      'M'                                    98
      *
     C                   MOVE      *BLANKS       DD1SQN            2
     C                   MOVE      *BLANKS       DD2SQN            2
     C                   MOVE      *BLANKS       DD3SQN            2
     C                   MOVE      *BLANKS       DD4SQN            2
     C                   MOVE      *BLANKS       DD5SQN            2
     C                   MOVE      DD1TTL        SS1TTL
     C                   MOVE      DD1NAM        SS1NAM
     C                   MOVE      DD1INI        SS1INI
     C                   MOVE      DD1AD1        SS1AD1
     C                   MOVE      DD1AD2        SS1AD2
     C                   MOVE      DD1AD3        SS1AD3
     C                   MOVE      DD1PC1        SS1PC1
     C                   MOVE      DD1PC2        SS1PC2
     C                   MOVE      DD1BRT        SS1BRT
     C                   MOVE      DD1NIN        SS1NIN
     C                   MOVE      DD1DOB        SS1DOB
     C                   MOVE      DD1SQN        SS1SQN
     C                   MOVE      DD2TTL        SS2TTL
     C                   MOVE      DD2NAM        SS2NAM
     C                   MOVE      DD2INI        SS2INI
     C                   MOVE      DD2AD1        SS2AD1
     C                   MOVE      DD2AD2        SS2AD2
     C                   MOVE      DD2AD3        SS2AD3
     C                   MOVE      DD2PC1        SS2PC1
     C                   MOVE      DD2PC2        SS2PC2
     C                   MOVE      DD2BRT        SS2BRT
     C                   MOVE      DD2NIN        SS2NIN
     C                   MOVE      DD2DOB        SS2DOB
     C                   MOVE      DD2SQN        SS2SQN
     C                   MOVE      DD3ttL        SS3TTL
     C                   MOVE      DD3NAM        SS3NAM
     C                   MOVE      DD3INI        SS3INI
     C                   MOVE      DD3AD1        SS3AD1
     C                   MOVE      DD3AD2        SS3AD2
     C                   MOVE      DD3AD3        SS3AD3
     C                   MOVE      DD3PC1        SS3PC1
     C                   MOVE      DD3PC2        SS3PC2
     C                   MOVE      DD3BRT        SS3BRT
     C                   MOVE      DD3NIN        SS3NIN
     C                   MOVE      DD3DOB        SS3DOB
     C                   MOVE      DD3SQN        SS3SQN
     C                   MOVE      DD4TTL        SS4TTL
     C                   MOVE      DD4NAM        SS4NAM
     C                   MOVE      DD4INI        SS4INI
     C                   MOVE      DD4AD1        SS4AD1
     C                   MOVE      DD4AD2        SS4AD2
     C                   MOVE      DD4AD3        SS4AD3
     C                   MOVE      DD4PC1        SS4PC1
     C                   MOVE      DD4PC2        SS4PC2
     C                   MOVE      DD4BRT        SS4BRT
     C                   MOVE      DD4NIN        SS4NIN
     C                   MOVE      DD4DOB        SS4DOB
     C                   MOVE      DD4SQN        SS4SQN
     C                   MOVE      DD5TTL        SS5TTL
     C                   MOVE      DD5NAM        SS5NAM
     C                   MOVE      DD5INI        SS5INI
     C                   MOVE      DD5AD1        SS5AD1
     C                   MOVE      DD5AD2        SS5AD2
     C                   MOVE      DD5AD3        SS5AD3
     C                   MOVE      DD5PC1        SS5PC1
     C                   MOVE      DD5PC2        SS5PC2
     C                   MOVE      DD5BRT        SS5BRT
     C                   MOVE      DD5NIN        SS5NIN
     C                   MOVE      DD5DOB        SS5DOB
     C                   MOVE      DD5SQN        SS5SQN
     C                   MOVE      DDTXIN        SSTXIN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
      * Customer number
      * Account Holder Type
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCUSN            6
     C                   PARM                    DDAHLT            1
 
      ** Customer Base Rate Tax
     C                   PARM                    CuBrt
 
      *
      ** OUTPUTS
 
      ** Customer Base Rate Tax OK indicators
     C                   PARM                    OKCuBrt
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Changed Party Name Array
     C                   PARM                    ChgNamArr
      *
      * Valid BRT file layout (DS) to/from caller
     C                   PARM                    BrtFilFmt
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUDTV013
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDCUSD7VL'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEB            6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
