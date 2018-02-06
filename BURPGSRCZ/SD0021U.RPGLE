      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  DFTACTGRP(*NO) ACTGRP(*CALLER)                               *                       CAP084
/*EXI *  TEXT('Midas BU BackGnd Upd for CCY files Exec User Pgm')
     F********************************************************************
     F*
     F*  Midas Standing Data module
     F*
     F*     Background update of old currency codes files
     F*
      *  (c) Finastra International Limited 2001                      *
     F*
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CAP084             Date 26Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01251             Date 03Feb90               *
     F*                     E18931           DATE  30NOV89
     F*                     S01230           DATE  07/11/89               S01230
     F*                     S01229           DATE  20/10/89               S01229
     F*                     E19315           DATE  25/08/89
     F*                     E18327           DATE  22/05/89
     F*
     F********************************************************************
     F*                                                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*     CAP084  - Wrapper project - convert to ILE                   *
     F*     S01251  -  SYNON FIELD NAME CHANGES                          *S01229
     F*     E18931  -  ADDITIONAL FIELD PROGRAM DRS MM SPOT DATE         *E18931
     F*     S01230  - STANDARDISE PROGRAMS                               *S01230
     F*     S01229  -  SYNON FIELD NAME CHANGES                          *S01229
     F*     E19315 - TABTG40 IS NOW ONLY KEYED ON THE CURRENCY           *E19315
     F*              FIELD SO ITS KEY LIST NEEDS CHANGING                *E19315
     F*                                                                  *
     F*     E18327 - RE-INSTATE PARAMETER THAT WAS ASTERISKED OUT        *E18327
     F*                                                                  *
     F********************************************************************
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*       20      Chain CCY Failed/Error TABTG10
     F*       21      Chain CCY Failed/Error TABTG20
     F*       22      Chain CCY Failed/Error TABTG40
     F*       30      Error on old CCY files
     F*       31      Error on old CCY files
     F*       32      Error on Header or Trailer files
     F*
     F********************************************************************
     FTABTG10   UF A E           K DISK
     F                                     COMMIT
     FTABTG20   UF A E           K DISK
     F                                     COMMIT
     FTABTG40   UF A E           K DISK
     F                                     COMMIT
     FTABLETA   UF   E           K DISK
     F                                     COMMIT
     FTABLETXL  UF   E           K DISK
     F                                     COMMIT
      /EJECT
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D*                                                                   S01230
     D********************************************************************S01230
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
     D* Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
     I********************************************************************S01230
      /EJECT                                                              S01230
     I*
     I* RENAME RECORD ID ON HEADER FILE TO AVOID OVERWRITING
     I*
     ITABLETAF
     I              RECT                        RECTA
     I*                                                                   S01230
      /EJECT
     C*
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7            Return Code
     C*********************PARM           WCCY    3        Currency Code  S01229
     C*********************PARM           WTACC   4        Spot Trd Acc EqS01229
     C*********************PARM           WTEQV   4        Fwd Trd Acc EquS01229
     C*********************PARM           WSWQV   4        Swap Trd Acc EqS01229
     C                   PARM                    WCYCD             3            Currency Code  S0122
     C**********         PARM                    WSPAE             4            Spot TrS01229 CGL029
     C**********         PARM                    WFTAE             4            Fwd TrdS01229 CGL029
     C**********         PARM                    WSWAE             4            Swap TrS01229 CGL029
     C**********         PARM                    WTAC4             4            Trd Acc       CGL029
     C**********         PARM                    WTAC5             4            Trd Acc       CGL029
     C                   PARM                    WSPAE            10                          CGL029
     C                   PARM                    WFTAE            10                          CGL029
     C                   PARM                    WSWAE            10                          CGL029
     C                   PARM                    WTAC4            10                          CGL029
     C                   PARM                    WTAC5            10                          CGL029
     C*********************PARM           WCEDN   2        Cedel Dflt NostS01229
     C                   PARM                    WCDFN             2            Cedel Dflt NostS0122
     C*********************PARM           WEUDN   2        EurClr Dflt NosS01229
     C                   PARM                    WECDN             2            EurClr Dflt NosS0122
     C                   PARM                    WLCD              5 0          Last Change Date
     C*********************PARM           WCHTP   1        Last Change TypS01229
     C*********************PARM           WCCNM  14        Currency Name  S01229
     C*********************PARM           WSPOT  138       Spot Rate      S01229
     C*********************PARM           WCCYS   3        Swift CCY Code S01229
     C*********************PARM           WCDP    10       No Dec Places  S01229
     C*********************PARM           WTNOT   10       Telex Notice DaS01229
     C*********************PARM           WPART  138       Par Rate       S01229
     C                   PARM                    WTYLC             1            Last Change TypS0122
     C                   PARM                    WCYNM            14            Currency Name  S0122
     C                   PARM                    WSPRT            13 8          Spot Rate      S0122
     C                   PARM                    WSWCY             3            Swift CCY Code S0122
     C                   PARM                    WNBDP             1 0          No Dec Places  S0122
     C                   PARM                    WTXND             1 0          Telex Notice DaS0122
     C                   PARM                    WPRRT            13 8          Par Rate       S0122
     C                   PARM                    WSRC1             4 0          Stat Rtn Code 1
     C                   PARM                    WSRC2             4 0          Stat Rtn Code 2
     C*********************PARM           WDCCY   1        Dealing CCY IndS01229
     C                   PARM                    WDLCI             1            Dealing CCY IndS0122
     C*********************PARM           WSSNO   20       Sort Seq No    S01229
     C                   PARM                    WSSNB             2 0          Sort Seq No    S0122
     C                   PARM                    WERLC            13 8          Exch Rate Limits
     C                   PARM                    WMDIN             1            M/D Indicator
     C*********************PARM           WMDINA  1        M/D Ind Par    S01229
     C*********************PARM           WMDINB  1        M/D Ind Hist BkS01229
     C*********************PARM           WXRMD   1        M/D Ind ExchangS01229
     C*********************PARM           WNSNM  10        Nostro ShortnamS01229
     C                   PARM                    WMDPR             1            M/D Ind Par    S0122
     C                   PARM                    WMDHB             1            M/D Ind Hist BkS0122
     C                   PARM                    WMDEX             1            M/D Ind ExchangS0122
     C                   PARM                    WNOSN            10            Nostro ShortnamS0122
     C                   PARM                    WSPDY             3 0          Spot Days
     C*                    PARM           WHGSP  138       High Spot Rate
     C*                    PARM           WLOSP  138       Low Spot Rate
     C*********************PARM           WFXSP   80       DRS FX Spot DatS01229
     C                   PARM                    WFXSD             8 0          DRS FX Spot DatS0122
     C*                    PARM           WMSPD   80       DRS MM Spot Date
     C*********************PARM           WMSPD   80       DRS MM SpE18327S01251
     C                   PARM                    WMMSD             8 0          DRS MM Spot DatS0125
     C                   PARM                    WNQDP             1 0          Norm Quote Dec Pl
     C*********************PARM           WDICM   1        Dflt Int Calc  S01229
     C*********************PARM           WSEXP   10       Scaling ExponenS01229
     C*********************PARM           WEURB  29        Eurobond Data  S01229
     C*********************PARM           WHBER  138       Hist Bkg Rate  S01229
     C*********************PARM           WECC1   20       Euroclear Num 1S01229
     C*********************PARM           WECC2   20       Euroclear Num 2S01229
     C*********************PARM           WCACC   3        Cedel Alpha CodS01229
     C*********************PARM           WCNCC   20       Cedel Num Code S01229
     C*********************PARM           WHFRI   1        Holiday Friday S01229
     C*********************PARM           WHSAT   1        Holiday SaturdaS01229
     C*********************PARM           WHSUN   1        Holiday Sunday S01229
     C                   PARM                    WDICB             1            Dflt Int Calc  S0122
     C                   PARM                    WSCEX             1 0          Scaling ExponenS0122
     C                   PARM                    WEBDA            29            Eurobond Data  S0122
     C                   PARM                    WHBRT            13 8          Hist Bkg Rate  S0122
     C                   PARM                    WENC1             2 0          Euroclear Num 1S0122
     C                   PARM                    WENC2             2 0          Euroclear Num 2S0122
     C                   PARM                    WCACD             3            Cedel Alpha CodS0122
     C                   PARM                    WCNMC             2 0          Cedel Num Code S0122
     C                   PARM                    WFRIH             1            Holiday Friday S0122
     C                   PARM                    WSATH             1            Holiday SaturdaS0122
     C                   PARM                    WSUNH             1            Holiday Sunday S0122
     C                   PARM                    WDPBF             1 0          Dec Place Big Fig
     C*********************PARM           WBSPR  138       Buy Spread RateS01229
     C*********************PARM           WBSSG   1        Buy Spread SignS01229
     C*********************PARM           WSSPR  138       Sell Spread RatS01229
     C*********************PARM           WSSSG   1        Sell Spread SigS01229
     C                   PARM                    WBYSR            13 8          Buy Spread RateS0122
     C                   PARM                    WBYSS             1            Buy Spread SignS0122
     C                   PARM                    WSLSR            13 8          Sell Spread RatS0122
     C                   PARM                    WSLSS             1            Sell Spread SigS0122
     C*
      /EJECT
     C****************************************************************
     C*
     C*   M A I N L I N E   P R O G R A M
     C*
     C****************************************************************
     C*
     C* Set up keylist for TABTG40
     C*
     C     TABKEY        KLIST
     C***********          KFLD           KRECT   20       Record Type - nE19315
     C***********          KFLD           KZZ006  6        Filler         E19315
     C                   KFLD                    KCCY              3            Currency Code  E1931
     C***********          KFLD           KSREC   10       Sub Record TypeE19315
     C*
     C                   Z-ADD     20            KRECT             2 0          Record Type - nE1931
     C                   MOVE      *BLANK        KZZ006            6            Filler         E1931
     C*********************MOVE WCCY      KCCY             Curr CodeE19315S01229
     C                   MOVE      WCYCD         KCCY                           Curr CodeE19315S0122
     C                   Z-ADD     4             KSREC             1 0          Sub Record TypeE1931
     C*
     C* If record has been inserted, Chain to old Currency files and check
     C* that record does not already exist on these files.
     C*
     C***********WCHTP     IFEQ 'I'                                       S01229
     C     WTYLC         IFEQ      'I'                                                         S0122
     C*
     C***********WCCY      CHAINTABTG10              20    Chain failed   S01229
     C     WCYCD         CHAIN     TABTG10                            20        Chain failed   S0122
     C*
     C* If CHAIN succeded but record is deleted (*) seton indicators 20 & 40
     C*
     C     *IN20         IFEQ      '0'
     C     RECI          ANDEQ     '*'                                          Record ID
     C                   SETON                                        2040
     C                   END
     C*
     C***********WCCY      CHAINTABTG20              21    Chain failed   S01229
     C     WCYCD         CHAIN     TABTG20                            21        Chain failed   S0122
     C*
     C* If CHAIN succeded but record is deleted (*) seton indicators 21 & 41
     C*
     C     *IN21         IFEQ      '0'
     C     RECI          ANDEQ     '*'                                          Record ID
     C                   SETON                                        2141
     C                   END
     C*
     C     TABKEY        CHAIN     TABTG40                            22        Chain failed
     C*
     C* If CHAIN succeded but record is deleted (*) seton indicators 22 & 42
     C*
     C     *IN22         IFEQ      '0'
     C     RECI          ANDEQ     '*'                                          Record ID
     C                   SETON                                        2242
     C                   END
     C*
     C* If record does not exist then execute subroutine to move parameters
     C* recieved into file fields and write a new record to each file.
     C*
     C     *IN20         IFEQ      '1'
     C     *IN21         ANDEQ     '1'
     C     *IN22         ANDEQ     '1'
     C*
     C                   EXSR      MOVESR
     C*
     C                   Z-ADD     1             SREC                           Sub Record Type
     C     *IN40         IFEQ      '0'
     C                   WRITE     TABTG10F                             31       ERROR
     C                   ELSE
     C                   UPDATE    TABTG10F                             31       ERROR
     C                   END
     C*
     C                   Z-ADD     2             SREC                           Sub Record Type
     C     *IN41         IFEQ      '0'
     C                   WRITE     TABTG20F                             31       ERROR
     C                   ELSE
     C                   UPDATE    TABTG20F                             31       ERROR
     C                   END
     C*
     C                   Z-ADD     4             SREC                           Sub Record Type
     C     *IN42         IFEQ      '0'
     C                   WRITE     TABTG40F                             31       ERROR
     C                   ELSE
     C                   UPDATE    TABTG40F                             31       ERROR
     C                   END
     C*
     C                   END
     C*
     C* If record found on file(s) set error
     C*
     C*
     C     *IN20         IFEQ      '0'
     C     *IN21         OREQ      '0'
     C     *IN22         OREQ      '0'
     C                   SETON                                        31
     C                   END
     C*
     C     *IN31         IFEQ      '1'
     C                   MOVE      '*ERROR*'     W0RTN
     C                   END
     C*
     C* Record is not an Insert
     C*
     C                   END
     C*
     C* If record has been changed, retrieve record from file
     C*
     C***********WCHTP     IFEQ 'A'                                       S01229
     C     WTYLC         IFEQ      'A'                                                         S0122
     C***********WCCY      CHAINTABTG10              20    Chain failed   S01229
     C     WCYCD         CHAIN     TABTG10                            20        Chain failed   S0122
     C*
     C***********WCCY      CHAINTABTG20              21    Chain failed   S01229
     C     WCYCD         CHAIN     TABTG20                            21        Chain failed   S0122
     C*
     C     TABKEY        CHAIN     TABTG40                            22        Chain failed
     C*
     C*
     C*
     C* If record found move received parameters into file fields and update
     C*
     C     *IN20         IFEQ      '0'
     C     *IN21         ANDEQ     '0'
     C     *IN22         ANDEQ     '0'
     C*
     C                   EXSR      MOVESR
     C*
     C                   Z-ADD     1             SREC                           Sub Record Type
     C                   UPDATE    TABTG10F                             30      ERROR
     C*
     C                   Z-ADD     2             SREC                           Sub Record Type
     C                   UPDATE    TABTG20F                             30      ERROR
     C*
     C                   Z-ADD     4             SREC                           Sub Record Type
     C                   UPDATE    TABTG40F                             30      ERROR
     C*
     C                   END
     C*
     C* If record not found or error occurred on update set error parameter
     C*
     C     *IN20         IFEQ      '1'
     C     *IN21         OREQ      '1'
     C     *IN22         OREQ      '1'
     C     *IN30         OREQ      '1'
     C                   MOVE      '*ERROR*'     W0RTN
     C                   END
     C*
     C*
     C*
     C* Record is not a changed record
     C*
     C                   END
     C*
     C* If record is Deleted from new file set flag for Deletion on old file
     C* if a record exists
     C*
     C***********WCHTP     IFEQ 'D'                                       S01229
     C***********WCCY      CHAINTABTG10              20    CHAIN FAILED   S01229
     C***********WCCY      CHAINTABTG20              21    CHAIN FAILED   S01229
     C     WTYLC         IFEQ      'D'                                                         S0122
     C     WCYCD         CHAIN     TABTG10                            20        CHAIN FAILED   S0122
     C     WCYCD         CHAIN     TABTG20                            21        CHAIN FAILED   S0122
     C     TABKEY        CHAIN     TABTG40                            22        CHAIN FAILED
     C*
     C                   MOVE      '*'           RECI                           Record ID
     C*********************MOVE WCHTP     CHTP             Last Change TypS01229
     C                   MOVE      WTYLC         CHTP                           Last Change TypS0122
     C*
     C* If record found on TABTG10 flag for Deletion
     C*
     C     *IN20         IFEQ      '0'
     C*
     C                   Z-ADD     1             SREC                           Sub Record Type
     C                   UPDATE    TABTG10F                             31      ERROR
     C                   END
     C*
     C* If record found on TABTG20 flag for Deletion
     C*
     C     *IN21         IFEQ      '0'
     C*
     C                   Z-ADD     2             SREC                           Sub Record Type
     C                   UPDATE    TABTG20F                             31      ERROR
     C                   END
     C*
     C* If record found on TABTG40 flag for Deletion
     C*
     C     *IN22         IFEQ      '0'
     C*
     C                   Z-ADD     4             SREC                           Sub Record Type
     C                   UPDATE    TABTG40F                             31      ERROR
     C                   END
     C*
     C* If error occured on Delete set error parameter
     C*
     C     *IN31         IFEQ      '1'
     C                   MOVE      '*ERROR*'     W0RTN
     C                   END
     C*
     C                   END
     C*
     C* If no errors have occurred on TABTG files
     C*
     C     W0RTN         IFEQ      *BLANKS                                      Return Code
     C*
     C* Retrieve old trailer file record
     C*
     C     '20'          CHAIN     TABLETXF                           32        CHAIN FAILED
     C*
     C* If CHAIN to file successful
     C*
     C     *IN32         IFEQ      '0'
     C*
     C* If first access to the file then get header record
     C*
     C     NINS          ANDEQ     0                                            No. Inserts
     C     NAMD          ANDEQ     0                                            No. Amends
     C     NDEL          ANDEQ     0                                            No. Deletes
     C*
     C                   READ      TABLETAF                               32      EOF
     C*
     C* If header record found then set print indicator and update
     C*
     C     *IN32         IFEQ      '0'
     C                   ADD       1             ICUR
     C                   UPDATE    TABLETAF                             32        ERROR
     C                   END
     C*
     C                   END
     C*
     C* If no errors
     C*
     C     *IN32         IFEQ      '0'
     C*
     C* Update as appropriate the number of inserts, amends or deletes
     C* on the trailer file
     C*
     C***********WCHTP     IFEQ 'I'                                       S01229
     C     WTYLC         IFEQ      'I'                                                         S0122
     C                   ADD       1             NINS                           No. Inserts
     C                   END
     C*
     C***********WCHTP     IFEQ 'A'                                       S01229
     C     WTYLC         IFEQ      'A'                                                         S0122
     C                   ADD       1             NAMD                           No. Amends
     C                   END
     C*
     C***********WCHTP     IFEQ 'D'                                       S01229
     C     WTYLC         IFEQ      'D'                                                         S0122
     C                   ADD       1             NDEL                           No. Deletes
     C                   END
     C*
     C                   UPDATE    TABLETXF                             32        ERROR
     C*
     C                   END
     C*
     C* Check for any errors and set error parameter for return to new file
     C* maintenance program
     C*
     C     *IN32         IFEQ      '1'
     C                   MOVE      '*ERROR*'     W0RTN                          Return Code
     C                   END
     C*
     C                   END
     C*
     C                   SETON                                        LR        Close Files
     C                   RETURN                                                 Exit
     C*
     C**********************************************************************
     C*
     CSR   MOVESR        BEGSR
     C*
     C* Subroutine to move all received parameters to file fields on when a
     C* record is Inserted or Amended on the New Currencies file.
     C*
     C                   MOVE      'D'           RECI                           Record ID
     C                   Z-ADD     20            RECT                           Record Type - n
     C*
     C*********************MOVE WCCY      CCY              Currency Code  S01229
     C*********************MOVE WTACC     TACC             Spot Trd Acc EqS01229
     C*********************MOVE WTEQV     TEQV             Fwd Trd Acc EquS01229
     C*********************MOVE WSWQV     SWQV             Swap Trd Acc EqS01229
     C                   MOVE      WCYCD         CCY                            Currency Code  S0122
     C                   MOVE      WSPAE         TACC                           Spot Trd Acc EqS0122
     C                   MOVE      WFTAE         TEQV                           Fwd Trd Acc EquS0122
     C                   MOVE      WSWAE         SWQV                           Swap Trd Acc EqS0122
     C                   MOVE      WTAC4         TAC4                           Trd Acc Code 4
     C                   MOVE      WTAC5         TAC5                           Trd Acc Code 5
     C*********************MOVE WCEDN     CEDN             Cedel Dflt NostS01229
     C                   MOVE      WCDFN         CEDN                           Cedel Dflt NostS0122
     C*********************MOVE WEUDN     EUDN             EurClr Dflt NosS01229
     C                   MOVE      WECDN         EUDN                           EurClr Dflt NosS0122
     C                   Z-ADD     WLCD          LCD                            Last Change Date
     C*********************MOVE WCHTP     CHTP             Last Change TypS01229
     C*********************MOVE WCCNM     CCNM             Currency Name  S01229
     C*********************Z-ADDWSPOT     SPOT             Spot Rate      S01229
     C*********************MOVE WCCYS     CCYS             Swift CCY Code S01229
     C*********************Z-ADDWCDP      CDP              No Dec Places  S01229
     C*********************Z-ADDWTNOT     TNOT             Telex Notice DaS01229
     C*********************Z-ADDWPART     PART             Par Rate       S01229
     C                   MOVE      WTYLC         CHTP                           Last Change TypS0122
     C                   MOVE      WCYNM         CCNM                           Currency Name  S0122
     C                   Z-ADD     WSPRT         SPOT                           Spot Rate      S0122
     C                   MOVE      WSWCY         CCYS                           Swift CCY Code S0122
     C                   Z-ADD     WNBDP         CDP                            No Dec Places  S0122
     C                   Z-ADD     WTXND         TNOT                           Telex Notice DaS0122
     C                   Z-ADD     WPRRT         PART                           Par Rate       S0122
     C*
     C* Z-ADD packed numeric fields to zoned numeric and then MOVE to
     C* character fields
     C*
     C                   Z-ADD     WSRC1         ZSRC1             4 0          Stat Rtn Code 1
     C                   MOVE      ZSRC1         SRC1                           Stat Rtn Code 1
     C*
     C                   Z-ADD     WSRC2         ZSRC2             4 0          Stat Rtn Code 2
     C                   MOVE      ZSRC2         SRC2                           Stat Rtn Code 2
     C*
     C*********************MOVE WDCCY     DCCY             Dealing CCY IndS01229
     C                   MOVE      WDLCI         DCCY                           Dealing CCY IndS0122
     C*********************Z-ADDWSSNO     SSNO             Sort Seq No    S01229
     C                   Z-ADD     WSSNB         SSNO                           Sort Seq No    S0122
     C                   Z-ADD     WERLC         ERLC                           Exch Rate Limits
     C*
     C* Convert values of the Multiply/Divide Indicators for the old files
     C*
     C     WMDIN         IFEQ      'M'                                          Multiply
     C                   Z-ADD     1             MDIN                           M/D Indicator
     C                   END
     C     WMDIN         IFEQ      'D'                                          Divide
     C                   Z-ADD     0             MDIN                           M/D Indicator
     C                   END
     C*
     C***********WMDINA    IFEQ 'M'                        Multiply       S01229
     C     WMDPR         IFEQ      'M'                                          Multiply       S0122
     C                   Z-ADD     1             MDINA                          M/D Ind Par    S0122
     C                   END
     C***********WMDINA    IFEQ 'D'                        Divide         S01229
     C     WMDPR         IFEQ      'D'                                          Divide         S0122
     C                   Z-ADD     0             MDINA                          M/D Ind Par    S0122
     C                   END
     C*
     C***********WMDINB    IFEQ 'M'                        Multiply       S01229
     C     WMDHB         IFEQ      'M'                                          Multiply       S0122
     C                   Z-ADD     1             MDINB                          M/D Ind Hist BkS0122
     C                   END
     C***********WMDINB    IFEQ 'D'                        Divide         S01229
     C     WMDHB         IFEQ      'D'                                          Divide         S0122
     C                   Z-ADD     0             MDINB                          M/D Ind Hist Bkg
     C                   END
     C*
     C*********************MOVE WXRMD     XRMD             M/D Ind ExchangS01229
     C                   MOVE      WMDEX         XRMD                           M/D Ind ExchangS0122
     C*********************MOVE WNSNM     NSNM             Nostro ShortnamS01229
     C                   MOVE      WNOSN         NSNM                           Nostro ShortnamS0122
     C                   Z-ADD     WSPDY         SPDY                           Spot Days
     C*                    Z-ADDWHGSP     HGSP             High Spot Rate
     C*                    Z-ADDWLOSP     LOSP             Low Spot Rate
     C*********************Z-ADDWFXSP     FXSP             DRS FX Spot DatS01229
     C                   Z-ADD     WFXSD         FXSP                           DRS FX Spot DatS0122
     C***********          Z-ADDWMSPD     MSPD             DRS MM SpE18931S01251
     C                   Z-ADD     WMMSD         MSPD                           DRS MM Spot DatS0125
     C                   Z-ADD     WNQDP         NQDP                           Norm Quote Dec Pl
     C*********************MOVE WDICM     DICM             Dflt Int Calc  S01229
     C*********************Z-ADDWSEXP     SEXP             Scaling ExponenS01229
     C*********************MOVE WEURB     EURB             Eurobond Data  S01229
     C*********************Z-ADDWHBER     HBER             Hist Bkg Rate  S01229
     C*********************Z-ADDWECC1     ECC1             Euroclear Num 1S01229
     C*********************Z-ADDWECC2     ECC2             Euroclear Num 2S01229
     C*********************MOVE WCACC     CACC             Cedel Alpha CodS01229
     C*********************Z-ADDWCNCC     CNCC             Cedel Num Code S01229
     C                   MOVE      WDICB         DICM                           Dflt Int Calc  S0122
     C                   Z-ADD     WSCEX         SEXP                           Scaling ExponenS0122
     C                   MOVE      WEBDA         EURB                           Eurobond Data  S0122
     C                   Z-ADD     WHBRT         HBER                           Hist Bkg Rate  S0122
     C                   Z-ADD     WENC1         ECC1                           Euroclear Num 1S0122
     C                   Z-ADD     WENC2         ECC2                           Euroclear Num 2S0122
     C                   MOVE      WCACD         CACC                           Cedel Alpha CodS0122
     C                   Z-ADD     WCNMC         CNCC                           Cedel Num Code S0122
     C*
     C** Set Bits for Holiday indicator, first setoff all Bits and then
     C** seton the relevent Bits for Holiday Days.
     C*
     C                   BITOFF    '01234567'    HIND
     C***********WHFRI     IFEQ 'Y'                        Holiday Friday S01229
     C     WFRIH         IFEQ      'Y'                                          Holiday Friday S0122
     C                   BITON     '4'           HIND                           Holiday Friday
     C                   END
     C***********WHSAT     IFEQ 'Y'                        Holiday SaturdaS01229
     C     WSATH         IFEQ      'Y'                                          Holiday SaturdaS0122
     C                   BITON     '5'           HIND                           Holiday Saturday
     C                   END
     C***********WHSUN     IFEQ 'Y'                        Holiday Sunday S01229
     C     WSUNH         IFEQ      'Y'                                          Holiday Sunday S0122
     C                   BITON     '6'           HIND                           Holiday Sunday
     C                   END
     C*
     C                   Z-ADD     WDPBF         DPBF                           Dec Place Big Fig
     C*********************Z-ADDWBSPR     BSPR             Buy Spread RateS01229
     C*********************MOVE WBSSG     BSSG             Buy Spread SignS01229
     C*********************Z-ADDWSSPR     SSPR             Sell Spread RatS01229
     C*********************MOVE WSSSG     SSSG             Sell Spread SigS01229
     C                   Z-ADD     WBYSR         BSPR                           Buy Spread RateS0122
     C                   MOVE      WBYSS         BSSG                           Buy Spread SignS0122
     C                   Z-ADD     WSLSR         SSPR                           Sell Spread RatS0122
     C                   MOVE      WSLSS         SSSG                           Sell Spread SigS0122
     C*
     CSR   MOVEND        ENDSR
**CTDATA CPY@
(c) Finastra International Limited 2001
