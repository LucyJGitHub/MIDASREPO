     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas BIC Directory File Desc Initialise')             *
      *****************************************************************
      *                                                               *
      *  Midas - S.W.I.F.T Direct Link                                *
      *                                                               *
      *  MS000002 - MIDAS BIC Directory File Desc Initialise          *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022833           Date 11Oct13               *
      *                 CFT050  *CREATE    Date 03Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *     MD022833 - CFT050 Swiftref - CFFS MEBICFPD Sequence       *
      *                numbers totally different - we may be missing  *
      *                fields on the screen as a result               *
      *     CFT050 - SWIFTRef Directories upload                      *
      *                                                               *
      *****************************************************************
      *
     FMEBICFPD  UF   E             DISK
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D Field           S             10    DIM(42) CTDATA PERRCD(1)                         MD022833
     D Desc            S             50    DIM(42) CTDATA PERRCD(1)                         MD022833
      *
     D WSeqNbr         S              5S 0 INZ(10)
     D Ctr             S              3S 0 INZ(1)                                           MD022833
      *
     C     1             SETLL     MEBICFD0
     C                   READ(E)   MEBICFPD
      *
     C                   DOW       WSeqNbr <= 00500
     C                   EVAL      MEXCL = *BLANKS
     C                   EVAL      MSEQN = WSeqNbr
     C                   EVAL      MFILE = '1'
     C                   IF        WSeqNbr = 00010
     C                   EVAL      MEXCL = 'E'
     C                   ENDIF
     C                   IF        Ctr >= 3 AND Ctr <= 42                                   MD022833
     C                   EVAL      WHFLDE = Field(Ctr)                                      MD022833
     C                   EVAL      WHFTXT = Desc(Ctr)                                       MD022833
     C                   ENDIF                                                              MD022833
     C                   IF        Ctr >= 45 and Ctr <= 50                                  MD022833
     C                   EVAL      MEXCL = 'E'                                              MD022833
     C                   ENDIF                                                              MD022833
     C                   UPDATE    MEBICFD0
      *
     C                   EVAL      WSeqNbr = WSeqNbr + 10
     C                   EVAL      Ctr = Ctr + 1                                            MD022833
     C                   READ(E)   MEBICFPD
     C                   ENDDO
      *
     C**********         EVAL      WSeqNbr = 00010                                          MD022833
     C                   EVAL      WSeqNbr = 01000                                          MD022833
     C                   DOW       NOT %EOF
     C                   EVAL      MEXCL = *BLANKS
     C                   EVAL      MSEQN = WSeqNbr
     C                   EVAL      MFILE = '2'
     C*********          IF        WSeqNbr = 00010                                          MD022833
     C                   IF        WSeqNbr = 01000                                          MD022833
     C                   EVAL      MEXCL = 'E'
     C                   ENDIF
     C                   UPDATE    MEBICFD0
      *
     C                   EVAL      WSeqNbr = WSeqNbr + 10
     C                   READ(E)   MEBICFPD
     C                   ENDDO
      *
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      ********************************************************************
      *                                                                                     MD022833
      ** Added new array Field and Desc                                                     MD022833
      *                                                                                     MD022833
**  CPY@
(c) Finastra International Limited 2013
**  Field
B3FLAG
B3KEY
B3UBIC
B3NATI
B3CHIP
B3LEIC
B3INS1
B3INS2
B3INS3
B3BIN1
B3BIN2
B3POBN
B3ADD1
B3ADD2
B3ADD3
B3ADD4
B3CITY
B3CPS1
B3CPS2
B3CPS3
B3ZIP
B3CNT1
B3CNT2
B3ISOC
B3STYP
B3BRQA
B3SER1
B3SER2
B3OFTP
B3POKY
B3HOKY
B3LGTP
B3LGPK
B3GRTP
B3GPKY
B3ISST
B3CGKY
B3BICC
B3BRCD
B3CBIC
B3TMZN
B3NWCY
**  Desc
Modification Flag
Record Key
Unique BIC Code
National ID
CHIPS UID
ISO LEI Code
Institution Name 1
Institution Name 2
Institution Name 3
Branch Information 1
Branch Information 2
POB Number
Street Name
Street Number
Building, bldg name, floor
Area
City Heading
CPS 1
CPS 2
CPS 3
Zip Code
Country Name 1
Country Name 2
ISO Country Code
Subtype Indicator
Branch Qualifier
Service Codes 1
Service Codes 2
Office Type
Parent Office Key
Head Office Key
Legal Type
Legal Parent Key
Group Type
Group Parent Key
Institution Status
Cooperative Group Key
BIC
Branch Code
Connected BIC Code
Timezone
Network Connectivity
