     H DEBUG
      *****************************************************************
/*XBI *  OVRDBF FILE(UPDFFDPD) TOFILE(QADSPFFD)                       *
/**** *  RPGBASE                                                      *                     MD060760
/*STD *  RPGBASEBND                                                   *                     MD060760
/*EXI *  TEXT('Midas UP Retrieve file field information')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP0890 - Retrieve file field information                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD060760           Date 10Nov22               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CUP031             Date 18Nov04               *
      *                 CUP028 *MOVED      Date 08Sep04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP004             Date 16Mar98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD060760 - Program does not compile, convert to RPGLE        *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP031  -  Amended so that if text description field is      *
      *             blank, retrieve column description as field       *
      *             description.                                      *
      *  CUP028  -  Moved from zone to global.                        *
      *  CUP004  -  Make upgrade of DTALIB files easier               *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *       20      End of file
      *       30      Chain - record not found
      *       69      Read, write, update or delete fail
      *
     FUPDFFDPD  IF   E             DISK
      *
      /EJECT
      * Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D ERR@            S             50    DIM(1) CTDATA PERRCD(1)
      *
      /SPACE 3
     C     *ENTRY        PLIST
     C                   PARM                    DESC             50
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C                   READ      UPDFFDPD                             6920
     C     *IN69         IFEQ      *ON
     C                   DUMP
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   MOVEL     WHFTXT        DESC
      *
      * If Text description field is blank, concatenate column headings as description        CUP031
     C     WHFTXT        IFEQ      *BLANKS
     C     WHCHD1        CAT       WHCHD2:1      WDES40           40
     C     WDES40        CAT       WHCHD3:1      WDES60           60
     C                   MOVEL     WDES60        DESC
     C                   ENDIF
      *
     C********   WHFTXT    IFNE *BLANKS                                                       CUP031
     C     DESC          IFNE      *BLANKS
     C                   MOVE      'Y'           FOUND             1
     C                   ELSE
     C                   MOVE      'N'           FOUND
     C                   ENDIF
      *
     C                   READ      UPDFFDPD                             6920
     C     *IN69         IFEQ      *ON
     C                   DUMP
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     FOUND         IFEQ      'N'
     C                   MOVEA     ERR@          DESC
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  ERR@
*** No field description available ***
