     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Retrieve member description details')
      *****************************************************************
      *                                                               *
      *  Midas - UT Module                                            *
      *                                                               *
      *  UTRTVMBRD - Retrieve member description details              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.03 ----------------------------------------*
      *  Prev Amend No. CTH001  *CREATE    Date 06Feb03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTH001 - Test Harness.                                       *
      *                                                               *
      *****************************************************************
      *
     D                 DS
     D RcvrLength              1      4B 0
     D                 DS
     D ErrorInf                1     15
     D Error1                  1      4B 0
     D Error2                  5      8B 0
     D Error3                  9     15
      *
      * Parameters for retrieval of member description
     DQUSM0300         DS                                                       Qdb Mbrd0300
     DRcvData                  1    384
     D QUSBRTN04               1      4B 0                                      Bytes Returned
     D QUSBAVL05               5      8B 0                                      Bytes Available
     D QUSDFILN01              9     18                                         Db File Name
     D QUSDFILL01             19     28                                         Db File Lib
     D QUSMN04                29     38                                         Member Name
     D QUSFILA02              39     48                                         File Attr
     D QUSST02                49     58                                         Src Type
     D QUSCD05                59     71                                         Crt Date
     D QUSSCD00               72     84                                         Src Change Date
     D QUSTD05                85    134                                         Text desc
     D QUSSFIL02             135    135                                         Src File
     D QUSEFIL00             136    136                                         Ext File
     D QUSLFIL00             137    137                                         Log File
     D QUSOS00               138    138                                         Odp Share
     D QUSERVED13            139    140                                         Reserved
     D QUSNBRCR00            141    144B 0                                      Num Cur Rec
     D QUSNBRDR00            145    148B 0                                      Num Dlt Rec
     D QUSDSS00              149    152B 0                                      Dat Spc Size
     D QUSAPS00              153    156B 0                                      Acc Pth Size
     D QUSNBRDM00            157    160B 0                                      Num Dat Mbr
     D QUSCD06               161    173                                         Change Date
     D QUSSD00               174    186                                         Save Date
     D QUSRD00               187    199                                         Rest Date
     D QUSED00               200    212                                         Exp Date
     D QUSNDU00              213    216B 0                                      Nbr Days Used
     D QUSDLU00              217    223                                         Date Lst Used
     D QUSURD00              224    230                                         Use Reset Date
     D QUSRSV102             231    232                                         Reserved1
     D QUSDSSM00             233    236B 0                                      Data Spc Sz Mlt
     D QUSAPSM00             237    240B 0                                      Acc Pth Sz Mlt
     D QUSMTC00              241    244B 0                                      Member Text Ccsid
     D QUSOAI00              245    248B 0                                      Offset Add Info
     D QUSLAI00              249    252B 0                                      Length Add Info
     D QUSNCRU00             253    256U 0                                      Num Cur Rec U
     D QUSNDRU01             257    260U 0                                      Num Dlt Rec U
     D QUSRSV204             261    266                                         Reserved2
     D QUSJM                 267    267                                         Join Member
     D QUSAPM                268    268                                         Acc Pth Maint
     D QUSSQLFT              269    278                                         SQL File Type
     D QUSRSV3               279    279                                         Reserved3
     D QUSAR                 280    280                                         Allow Read
     D QUSAW                 281    281                                         Allow Write
     D QUSAU01               282    282                                         Allow Update
     D QUSAD01               283    283                                         Allow Delete
     D QUSRSV4               284    284                                         Reserved4
     D QUSRFW                285    288B 0                                      Rcds Force Write
     D QUSMPDR               289    292B 0                                      Max Prct Dlt Rcd
     D QUSINBRR              293    296B 0                                      Init Num Rcd
     D QUSINBRR00            297    300B 0                                      Incr Num Rcd
     D QUSMNBRI              301    304B 0                                      Max Num Incr
     D QUSCNBRI              305    308U 0                                      Cur Num Incr
     D QUSRC                 309    312U 0                                      Rcd Capacity
     D QUSRFSN               313    322                                         Rcd Format Slct Name
     D QUSRFSL               323    332                                         Rcd Format Slct Lib
     D QUSNBRCI              333    334B 0                                      Num Cst Indexs
     D QUSOCI                335    338B 0                                      Offset Cst Indexs
     D QUSRSV5               339    384                                         Reserved5
      *
      /SPACE 3
      * Parameters passed to program
     C     *ENTRY        PLIST
     C                   PARM                    File             10            File name
     C                   PARM                    Library          10            Library name, *LIBL
      *                                                                         or *CURLIB
     C                   PARM                    Member           10            Member name, *FIRST
      *                                                                         or *LAST
     C                   PARM                    ErrorMsg          7            CPF message from API
     C                   PARM                    APIData         384            Data from API
      *
      * Set up parameters for API
     C                   Z-ADD     384           RcvrLength
     C                   MOVE      'MBRD0300'    Format            8
     C                   MOVEL     File          QualName         20
     C                   MOVE      Library       QualName
     C                   MOVE      '0'           OvrProc           1
     C                   Z-ADD     15            Error1
      *
     C                   CALL      'QUSRMBRD'
     C                   PARM                    RcvData
     C                   PARM                    RcvrLength
     C                   PARM                    Format
     C                   PARM                    QualName
     C                   PARM                    Member
     C                   PARM                    OvrProc
     C                   PARM                    ErrorInf
      * Move error message to parameter so that calling program can handle it.
     C                   MOVEL     Error3        ErrorMsg
      *
     C     ErrorMsg      IFEQ      *blanks
     C                   MOVEL     RcvData       APIData
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
