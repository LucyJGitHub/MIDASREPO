     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Holidays file       Special *RDR')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AOHOLS0 - READ ACCESS TO HOLIDAYS FILE (NON-STANDARD AO)     *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 139277             Date 21Jul98               *
      *                 CAP002             Date 01May98               *
     F*                    S01230             Date 23/11/89              *S01230
     F*                    S01230             DATE 06/11/89              *S01230
     F*                                                                  *
     F********************************************************************
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  139277 - Decimal data error problem:                         *
      *           prevent access to file with incorrect data.         *
      *           If the currency field is blank, return *NRF.        *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     S01230 - STANDARDISE ACCESS PROGRAMS                         *S01230
     F********************************************************************S01230
     F*
     F* ID F  C  H  L     FUNCTION OF INDICATORS
     F*
     F*       01       OPEN FILE
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       94       END OF FILE
     F*
     F********************************************************************
      /EJECT
     F*FSTART
      ************************************************************
     FSDHOLL2   IF   E           K DISK    USROPN
      * IN - @HOLPID  Holiday file fmt. (CYCD LOCN JDNB)                  S01230
      *                           Currency\Location\1st Jan Day Number    S01230
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D********************************************************************S01230
     D********************************************************************S01230
      /EJECT
     D*ISTART
      ************************************************************
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D***********D@FMT     E DSSDHOLD0                                    S01230
      *********** @HOLPHG - Holiday record format data structure          S01230
     D D@FMT         E DS                  EXTNAME(SDHOLPD)                     S01230
      * @HOLPID - Holiday record format data structure                    S01230
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)                       S01230
     D* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT        S01230
     D* OF THE FILE.                                                      S01230
      *                                                                   S01230
     D*********P@FMT       DS                            387              S01230
     D*********                               1   1 P@COPY                S01230
      *
     D P@CYCD          DS
      * Currency code
     D  K@CYCD                 1      3
      *
     D************P@DRSL      DS                                          S01230
     D************                            1   3 K@DRSL                S01230
     D P@LCCD          DS                                                       S01230
      * Location code
     D  K@LCCD                 1      3                                         S01230
      *
     D************P@NJNB      DS                                          S01230
     D************************************P   1   30K@NJNB                S01230
     D P@JDNB          DS                                                       S01230
      * 1st. Jan day no.
     D  K@JDNB                 1      3P 0                                      S01230
      *
     D @VARS           DS
      * Variables for access object
     D  SLOC                   1      3
      *
      ************************************************************
     D*                                                                   S01230
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
      * Copyright array
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)
      ************************************************************        S01230
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@CYCD                         I:Currency code
     C*********************PARM           P@DRSL           I:Location codeS01230
     C*********************PARM           P@NJNB           I:Input day no.S01230
     C                   PARM                    P@LCCD                         I:Location codeS0123
     C                   PARM                    P@JDNB                         I:Input day no.S0123
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
      * Re-set error indicators 90 - 92.
      *
     C                   MOVEA     '000'         *IN(90)
      *
      * If Location Code passed in is blank them move *** to Location     S01230
      * code and Y to Blank Location Entered in order to pass back        S01230
      * blanks in the Location Code                                       S01230
      *                                                                   S01230
     C     P@LCCD        IFEQ      *BLANKS                                      IF 1           S0123
     C                   MOVE      '***'         P@LCCD                                        S0123
     C                   END                                                    FI 1           S0123
      *                                                                   S01230
      * KEY FIELD LIST
      *
     C     K@KEY         KLIST
     C                   KFLD                    K@CYCD
     C*********************KFLD           K@DRSL                          S01230
     C*********************KFLD           K@NJNB                          S01230
     C                   KFLD                    K@LCCD                                        S0123
     C                   KFLD                    K@JDNB                                        S0123
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      SDHOLL2                              91        Open file
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 1 FREE PROG
     C                   CLOSE     SDHOLL2                              92        Close file
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 1
      *                                                                         139277
      * If the currency has been passed as a blank, then pass back              139277
      * 'No record found' and end program.                                      139277
      *                                                                         139277
     C     P@OPTN        IFEQ      '*PREV  '                                    139277
     C     P@CYCD        ANDEQ     *BLANK                                       139277
     C     P@OPTN        OREQ      '*SETGT '                                    139277
     C     P@CYCD        ANDEQ     *BLANK                                       139277
     C                   MOVE      '*NRF   '     P@RTCD                         139277
     C                   RETURN                                                 139277
     C                   ENDIF                                                  139277
      *
      * If the option is *PREV, then a location has been stored from a
      * previous call (it may be blank).
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 1
      *
      * If the location is still the same as before, then file pointer
      * is positioned correctly and can just read file.
      *
     C***********P@DRSL    IFEQ SLOC                        IF 2          S01230
     C     P@LCCD        IFEQ      SLOC                                          IF 2          S0123
      *
     C*********************READP@HOLPHG                9094               S01230
     C                   READP     @HOLPID                              9094                   S0123
      *
      * If currency and location retrieved are the same as those input,
      * and input date is between 1st Jan & 31st Dec dates, then a
      * record has been found and can be returned.
      *
     C     P@CYCD        IFEQ      DGCYCD                                         IF 3
     C***********P@DRSL    ANDEQDGDRSL                        AND         S01230
     C***********DGNJNB    ANDLEK@NJNB                        AND         S01230
     C***********K@NJNB    ANDLEDGNKNB                        AND         S01230
     C     P@LCCD        ANDEQ     DGLCCD                                          AND         S0123
     C     DGJDNB        ANDLE     K@JDNB                                          AND         S0123
     C     K@JDNB        ANDLE     DGDDNB                                          AND         S0123
      *
     C                   MOVE      *BLANKS       P@RTCD
     C*********************MOVE P@DRSL    SLOC                            S01230
     C                   MOVE      P@LCCD        SLOC                                          S0123
     C*********************MOVE D@FMT     P@FMT                           S01230
     C                   MOVEL     D@FMT         P@FMT                                         S0123
      *
     C                   ELSE                                                     ELSE 3
      *
      * If location code was not blank then a global holiday record may
      * still exist for the currency. Set option to *SETGT and blank
      * the location code so that an attempt is tried later on.
      *
     C***********P@DRSL    IFNE *BLANKS                       IF 4        S01230
     C     P@LCCD        IFNE      '***'                                           IF 4        S0123
      *
     C                   MOVE      '*SETGT '     P@OPTN
     C*********************MOVE *BLANKS   P@DRSL                          S01230
     C                   MOVE      *BLANKS       P@LCCD                                        S0123
      *
     C                   ELSE                                                      ELSE 4
      *
      * Location was already blank, so either currency or year were not
      * right. In either case, no record exists; locally or globally.
      *
     C                   MOVE      '*NRF   '     P@RTCD
     C*********************MOVE *BLANKS   SLOC                            S01230
     C                   MOVE      '***'         SLOC                                          S0123
      *
     C                   END                                                       FI 4
      *
     C                   END                                                      FI 3
      *
      * Location code did not match stored location code, so need to
      * re-position file pointer.
      *
     C                   ELSE                                                    ELSE 2
      *
     C                   MOVE      '*SETGT '     P@OPTN
      *
     C                   END                                                     FI 2
      *
     C                   END                                                    FI 1
      *
      * Since the option may have been changed from *PREV to *SETGT,
      * must check it explicitly again.
      *
     C     P@OPTN        IFEQ      '*SETGT '                                    IF 1
      *
      * Position file pointer and read previous record.
      *
     C***********K@KEY     SETGT@HOLPHG                90                 S01230
     C*********************READP@HOLPHG                9094               S01230
     C     K@KEY         SETGT     @HOLPID                              90                     S0123
     C                   READP     @HOLPID                              9094                   S0123
      *
      * If currency and location retrieved are the same as those input,
      * and input date is between 1st Jan & 31st Dec dates, then a
      * record has been found and can be returned.
      *
     C     P@CYCD        IFEQ      DGCYCD                                        IF 2
     C***********P@DRSL    ANDEQDGDRSL                       AND          S01230
     C***********DGNJNB    ANDLEK@NJNB                       AND          S01230
     C***********K@NJNB    ANDLEDGNKNB                       AND          S01230
     C     P@LCCD        ANDEQ     DGLCCD                                         AND          S0123
     C     DGJDNB        ANDLE     K@JDNB                                         AND          S0123
     C     K@JDNB        ANDLE     DGDDNB                                         AND          S0123
      *
     C                   MOVE      *BLANKS       P@RTCD
     C*********************MOVE P@DRSL    SLOC                            S01230
     C                   MOVE      P@LCCD        SLOC                                          S0123
     C*********************MOVE D@FMT     P@FMT                           S01230
     C                   MOVEL     D@FMT         P@FMT                                         S0123
      *
     C                   ELSE                                                    ELSE 2
      *
      * If location code is not blank, then global holiday record may
      * still exist.
      *
     C***********P@DRSL    IFNE *BLANKS                      IF 3         S01230
     C     P@LCCD        IFNE      '***'                                          IF 3         S0123
      *
     C*********************MOVE *BLANKS   K@DRSL                          S01230
     C                   MOVE      '***'         K@LCCD                                        S0123
     C***********K@KEY     SETGT@HOLPHG                90                 S01230
     C*********************READP@HOLPHG                9094               S01230
     C     K@KEY         SETGT     @HOLPID                              90                     S0123
     C                   READP     @HOLPID                              9094                   S0123
      *
      * If the currency still matches and location returned is blank
      * ie represented as three asterisks                                 S01230
      * and input date is between 1st Jan & 31st Dec dates, then a
      * holiday record was found.
      *
     C     P@CYCD        IFEQ      DGCYCD                                          IF 4
     C***********DGDRSL    ANDEQ*BLANKS                        AND        S01230
     C***********DGNJNB    ANDLEK@NJNB                         AND        S01230
     C***********K@NJNB    ANDLEDGNKNB                         AND        S01230
     C     DGLCCD        ANDEQ     '***'                                            AND        S0123
     C     DGJDNB        ANDLE     K@JDNB                                           AND        S0123
     C     K@JDNB        ANDLE     DGDDNB                                           AND        S0123
      *
     C                   MOVE      *BLANKS       P@RTCD
     C*********************MOVE *BLANKS   SLOC                            S01230
     C                   MOVE      '***'         SLOC                                          S0123
     C*********************MOVE D@FMT     P@FMT                           S01230
     C                   MOVEL     D@FMT         P@FMT                                         S0123
      *
     C                   ELSE                                                      ELSE 4
      *
      * No record was found
      *
     C                   MOVE      '*NRF   '     P@RTCD
     C*********************MOVE *BLANKS   SLOC                            S01230
     C                   MOVE      '***'         SLOC                                          S0123
     C                   MOVE      *BLANKS       P@FMT
      *
     C                   END                                                       FI 4
      *
     C                   ELSE                                                     ELSE 3
      *
      * Location was already blank, so either currency or year were not
      * right. In either case, no record exists; locally or globally.
      *
     C                   MOVE      '*NRF   '     P@RTCD
     C*********************MOVE *BLANKS   SLOC                            S01230
     C                   MOVE      '***'         SLOC                                          S0123
      *
     C                   END                                                      FI 3
      *
     C                   END                                                     FI 2
      *
     C                   END                                                    FI 1
      *
      * If any of indicators 90, 91 or 92 are on, then an I/O error
      * has occurred, so call DATABASE error handling program.
      *
     C     *IN90         IFEQ      '1'                                          IF 1
     C     *IN91         OREQ      '1'                                           OR
     C     *IN92         OREQ      '1'                                           OR
      *
     C                   DUMP
     C                   CALLB     'DBERRCTL'
      *
     C                   END                                                    FI 1
      *                                                                   S01230
      * If Location Code USED to find record = '***' then reset LCCD      S01230
      * to blanks.                                                        S01230
      *                                                                   S01230
     C     P@LCCD        IFEQ      '***'                                        IF 1           S0123
     C                   MOVE      *BLANKS       P@LCCD                                        S0123
     C                   END                                                    FI 1           S0123
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDHOLL2   AOHOLS0   Holidays file
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
