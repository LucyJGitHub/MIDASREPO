     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas AC Utility to calculate component times')
     F*****************************************************************
     F*                                                               *
     F*  Midas - System Control Module                            *
     F*                                                               *
     F*  AC0005 - Calculate component times.                          *
     F*                                                               *
     F*  Function: This program will calculate at implementation, be- *
     F*            fore Autocall is switched ON, the time it would    *
     F*            take each component to complete, during a normal   *
     F*            COB.                                               *
     F*                                                               *
     F*  Called By: None                                              *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058986           Date 11Oct21               *
      *  Prev Amend No. MD055891           Date 01Sep20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 099980             Date 23Feb96               *
     F*                 S01491 *CREATE     Date 01OCT94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD058986 - Add Logical Delete for components and dependencies*
      *  MD055891 - Deliverable Data Split for COB                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
     F*  099980 - Increase component times                            *
     F*  S01491 - Autocall.                                           *
     F*                                                               *
     F*****************************************************************
     F*****************************************************************
     F*
     FCBCOMSL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@DHREGG:@CBREGG)
     F*
     F*CBCMPNL0* UF   E           K DISK    INFSR(*PSSR)                                    MD055891
     F*
      /EJECT
      /TITLE FUNCTION OF INDICATORS
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
     F*   88  - Record not found on LF/CBCMPNL0                       *
     F*   89  - End of file on LB/CBCOMSL0                            *
     F*                                                               *
     F* U7+U8 - Database Error                                        *
     F*                                                               *
     F*****************************************************************
      /EJECT
     D/TITLE E-SPECIFICATIONS
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D LDA           E DS                  EXTNAME(LDA)
     D***  Local data area for database error details.
     D*
     D XTIME           DS
     D***  Time data structure.
     D  XHOR                   1      2  0
     D  XMIN                   3      4  0
     D  XSEC                   5      6  0
     D  TIMN                   1      6  0
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
     I*** Array for Object Copyright Statement.
     I*
      /EJECT
     I*
     I@CBREGG
     I***  Rename record field names of LF/CBCOMSL0
     I              DHCOTT                      CBCOTT
     I              DHCSEQ                      CBCSEQ
     I              DHCSTS                      CBCSTS
     I              DHCSHP                      CBCSHP
     I              DHCEPY                      CBCEPY
     I              DHCTSL                      CBCTSL
     I              DHCFOB                      CBCFOB
     I              DHCTXT                      CBCTXT
     I              DHCPRM                      CBCPRM
     I              DHCRQD                      CBCRQD
     I              DHCMOD                      CBCMOD
     I              DHCEMI                      CBCEMI
     I              DHCRES                      CBCRES
     I              DHCODP                      CBCODP
     I              DHCMEF                      CBCMEF
     I              DHCFRQ                      CBCFRQ
     I              DHCSDE                      CBCSDE
     I              DHCSTI                      CBCSTI
     I              DHCEDE                      CBCEDE
     I              DHCETI                      CBCETI
     I              DHCHTB                      CBCHTB
     I              DHCHTA                      CBCHTA
     I              DHCFAL                      CBCFAL
     I              DHEODT                      CBEODT
     I              DHEOMT                      CBEOMT
     I              DHBOMT                      CBBOMT
     I              DHEOYT                      CBEOYT
     I              DHEODC                      CBEODC
     I              DHEOMC                      CBEOMC
     I              DHBOMC                      CBBOMC
     I              DHEOYC                      CBEOYC
     I*
      /EJECT
     C/TITLE Main Processing
     C*
     C***  Copyright Statement.
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C     WWKEY         KLIST
     C                   KFLD                    WWCOTT           10
     C                   KFLD                    WWCSEQ            5
     C*
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANKS       DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'AC0005'      DBPGM
     C                   Z-ADD     *ZEROS        DBASE
     C                   OUT       LDA
     C*
     C                   READ      @CBREGG                                89
     C*
     C***  Do while not end of LF/CBCOMSL0
     C*
     C     *IN89         DOWEQ     '0'
     C*
     C***  Check if record exists on LF/CBCMPNL0
     C*
     C                   MOVEL     CBCOTT        WWCOTT
     C                   MOVEL     CBCSEQ        WWCSEQ
     C*
     C*****WWKEY         CHAIN     @DHREGG                            88                    MD055891
     C/EXEC SQL                                                                             MD055891
     C+ SELECT *                                                                            MD055891
     C+ into :CBCMPN                                                                        MD055891
     C+ from CBCMPJW0                                                                       MD055891
     C+ where DHCOTT = :WWCOTT and DHCSEQ = :WWCSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C*
     C******IN88         IFEQ      '1'                                                      MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C*
     C***  Record not found - Database Error.
     C*
     C     *LOCK         IN        LDA
     C                   MOVEL     WWCOTT        WKEY             15
     C                   MOVE      WWCSEQ        WKEY
     C                   MOVEL     'CBCMPNL0'    DBFILE                         *************
     C                   MOVEL     WKEY          DBKEY                          * DBASE 001 *
     C                   Z-ADD     1             DBASE                          *************
     C                   OUT       LDA
     C*
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   END
     C*
     C***  Convert start time (HHMMSS) to units of seconds
     C*
     C                   MOVE      CBCSTI        XTIME
     C     XHOR          MULT      60            SMIN              4 0
     C     XMIN          ADD       SMIN          SMIN
     C     SMIN          MULT      60            SSEC              5 0
     C     XSEC          ADD       SSEC          SSEC
     C*
     C***  Convert end time (HHMMSS) to units of seconds
     C*
     C                   MOVE      CBCETI        XTIME
     C     XHOR          MULT      60            EMIN              4 0
     C     XMIN          ADD       EMIN          EMIN
     C     EMIN          MULT      60            ESEC              5 0
     C     XSEC          ADD       ESEC          ESEC
     C*
     C***  Calculate the time taken for the component to finish
     C***  (end of day time) in units of seconds
     C*
     C***  End time is greater than or equal start time
     C*
     C     ESEC          IFGE      SSEC
     C     ESEC          SUB       SSEC          WWEODT            5 0
     C*
     C***  End time is less than start time
     C*
     C                   ELSE
     C     86400         SUB       SSEC          WWRK1             5 0
     C     WWRK1         ADD       ESEC          WWEODT
     C                   END
     C*
     C***  If component takes less than 2 minutes, set minimum time
     C***          to 2 minutes
     C*
     C     WWEODT        MULT      2             WWEODT                                        09998
     C     WWEODT        IFLT      120
     C     WWEODT        ADD       120           WWEODT
     C                   END
     C*
     C***  Compute for end of month time, beginning of month time,
     C***  and end of year time
     C*
     C     WWEODT        MULT      1.5           WWEOMT            6 0
     C     WWEODT        MULT      1.5           WWBOMT            6 0
     C     WWEODT        MULT      2             WWEOYT            6 0
     C*                                                                   099980
     C***  Add 10 minutes onto component                                  099980
     C*                                                                   099980
     C     WWEODT        ADD       600           WWEODT                                        09998
     C     WWEOMT        ADD       600           WWEOMT                                        09998
     C     WWEOYT        ADD       600           WWEOYT                                        09998
     C     WWBOMT        ADD       600           WWBOMT                                        09998
     C*
     C***  Convert end of day time back to HHMMSS format
     C*
     C     WWEODT        DIV       3600          XHOR
     C                   MVR                     WSEC              4 0
     C     WSEC          DIV       60            XMIN
     C                   MVR                     XSEC
     C                   Z-ADD     TIMN          DHEODT
     C*
     C***  Convert end of month time back to HHMMSS format
     C*
     C     WWEOMT        DIV       3600          XHOR
     C                   MVR                     WSEC
     C     WSEC          DIV       60            XMIN
     C                   MVR                     XSEC
     C                   Z-ADD     TIMN          DHEOMT
     C*
     C***  Convert beginning of month time back to HHMMSS format
     C*
     C     WWBOMT        DIV       3600          XHOR
     C                   MVR                     WSEC
     C     WSEC          DIV       60            XMIN
     C                   MVR                     XSEC
     C                   Z-ADD     TIMN          DHBOMT
     C*
     C***  Convert end of year time back to HHMMSS format
     C*
     C     WWEOYT        DIV       3600          XHOR
     C                   MVR                     WSEC
     C     WSEC          DIV       60            XMIN
     C                   MVR                     XSEC
     C                   Z-ADD     TIMN          DHEOYT
     C*
     C***  Update record on LF/CBCMPNL0 with the new details
     C*
     C**********         UPDATE    @DHREGG                                                  MD055891
     C/EXEC SQL                                                                             MD055891
     C+ update CBCMPXTD set                                                                 MD055891
     C+    DHEODT = :DHEODT                                                                 MD055891
     C+  , DHEOMT = :DHEOMT                                                                 MD055891
     C+  , DHBOMT = :DHBOMT                                                                 MD055891
     C+  , DHEOYT = :DHEOYT                                                                 MD055891
     C+ where DHCOTT = :WWCOTT and DHCSEQ = :WWCSEQ                                         MD055891
     C/END-EXEC                                                                             MD055891
     C*
     C***  Read next record on LF/CBCOMSL0
     C*
     C                   READ      @CBREGG                                89
     C*
     C                   END
     C*
     C                   MOVE      '1'           *INLR
     C                   RETURN
      /EJECT
     C/TITLE SR/*PSSR
     C*****************************************************************
     C*                                                               *
     C*  *PSSR  - Subroutine to handle Database Errors.               *
     C*                                                               *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR                                                   *** *PSSR ***
     C*
     C***  Dump and return to the calling program
     C*
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT
** CPY@ - OBJECT COPYRIGHT
(c) Finastra International Limited 2001
