     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Detail Screen')                *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDACRV1DP  - Midas SD Account Review detail screen           *
      *                                                               *
      *  Function:  This module displays the details screen of        *
      *             Account review selected                           *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDACRV1DF CF   E             WORKSTN

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,STDDECLARE

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,ERR_ARRAYS

     D/COPY ZACPYSRC,FVAL_ARRAY

     D/COPY ZACPYSRC,APICTLARR

     D/COPY ZACPYSRC,MSGHNDDCL

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

      ** Account Review Details in screen format
     D CrARScnFmt    E DS                  EXTNAME(SDACRFPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Account Review OK indicators
     D OKACRVFlag    E DS                  EXTNAME(SDEACRVPD)

     D WZ0             S              1    DIM(20) CTDATA PERRCD(20)

     D WEI             S              1    DIM(20)
     D WCOMP           S              1

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WCount          S              2P 0
     D WErr            S              2P 0
     D WEKYFD          S              1A
     D WEDTFD          S              1A
     D WINKC           S              1A
     D WINKE           S              1A
     D WINKL           S              1A
     D WINKU           S              1A
     D WINKV           S              1A
     D DDMRDT          S              7A
     D WRTCD           S              7A
     D WOPTN           S              7A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Main processing

     C                   EXSR      MAIN

      ** Return
     C                   SETON                                        LR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     MAIN          BEGSR

     D/COPY ZACPYSRC,MSGHNDDSP1

      ** Move 'OK' flags into array (for checking)

     C                   MOVEA     OKACRVFlag    WEI

      ** Set screen error indicators according to status of 'OK' flags

     C                   EVAL      WCount = 1
     C                   EVAL      WErr = 21

     C                   DOU       WCount > 20
     C                   IF        WEI(WCount) = 'N'
     C                             OR WEI(WCount) = 'W'
     C                   MOVEL     '1'           *IN(WErr)
     C                   ENDIF
     C                   EVAL      WCount = WCount + 1
     C                   EVAL      WErr = WErr + 1
     C                   ENDDO

      ** Position cursor on first field if no errors

     C     'N'           LOOKUP    WEI                                    69

     C                   IF        DDACTN = 'A'
     C                   MOVE      '1'           *IN72
     C                   ENDIF

     C                   IF        DDACTN = 'E' OR
     C                             WEDTFD = 'N'
     C                   MOVE      '1'           *IN70
     C                   MOVE      '1'           *IN74
     C                   MOVE      '1'           *IN71
     C                   MOVE      '1'           *IN81
     C                   ENDIF

     C                   IF        WCOMP = 'Y'
     C                   MOVE      '1'           *IN70
     C                   MOVE      '1'           *IN74
     C                   ENDIF

     C                   IF        WEKYFD = 'N'
     C                   MOVE      '1'           *IN73
     C                   ENDIF

     C                   IF        DDPUR1 = 'FATCA High Value +
     C                                      Account Review'
     C                   MOVE      '1'           *IN74
     C                   ENDIF

     C                   TIME                    DDTIME

      ** Write Message subfile, account review details
      ** and footer screen

     C                   WRITE     SDACRVS0
     C                   WRITE     SDACRVD1
     C                   WRITE     SDACRVF1

      ** Read Details Screen, If not write only

     C                   IF        WriteOnly <> 'Y'
     C                   READ      SDACRVD1                               99
     C                   ENDIF

      ** Clear message subfile
      ** Set screen error indicators off

     C                   SETOFF                                       212223
     C                   SETOFF                                       707172
     C                   SETOFF                                       7374

     C                   MOVEA     WZ0           *IN(21)

      ** Set return keys

     C                   MOVE      *INKC         WINKC
     C                   MOVE      *INKE         WINKE
     C                   MOVE      *INKL         WINKL
     C                   MOVE      *INKU         WINKU
     C                   MOVE      *INKV         WINKV

     C                   ENDSR

     D/COPY ZACPYSRC,MSGHNDDSP2

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

      ** INPUT PARAMETERS :
      ** Return code

     C                   PARM                    RetCodeIn

     C                   PARM                    DDCSSN
     C                   PARM                    DDCRNM
     C                   PARM                    DDCRTN
     C                   PARM                    CrARScnFmt
     C                   PARM                    WCOMP

      ** OUTPUTS
     C                   PARM                    OKACRVFlag

      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

     C                   PARM                    WEKYFD
     C                   PARM                    WEDTFD

      ** OUTPUT PARAMETERS :
      ** Function Keys

     C                   PARM                    WINKC
     C                   PARM                    WINKE
     C                   PARM                    WINKL
     C                   PARM                    WINKU
     C                   PARM                    WINKV

      ** Write screen with no read indicator
     C                   PARM                    WriteOnly

      ** Initialize program name

     C                   MOVEL     'SDACRV1DP'   DBPGM

      ** Move user and workstation ID to screen fields.

     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID

     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ

      ** Access bank details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     WRTCD
     C                   PARM      '*FIRST '     WOPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        WRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     WOPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DDMRDT = BJMRDT

     D/COPY SDCPYSRC,MSGHNDDATA

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRERR         BEGSR

     C                   MOVEL     'SDACRV1DP'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP

      **  Terminte the program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2014
** WZ0
00000000000000000000
