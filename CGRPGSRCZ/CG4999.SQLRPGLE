     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Source generator for extract programs')
/*OVRF*: OVRDBF (#SRCMBRI       ) (CGCPYSRC      )                  : *
/****F*:*CRTSRCPF QTEMP/#SRCMBRO************************************:**   CPK008
/*OVRF*: CRTSRCPF FILE(QTEMP/#SRCMBRO) RCDLEN(112)                  : *   CPK008
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG4999 - Source Generator for extract programs               *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPK008             Date 09Jun97               *
      *                 S01522             Date 22Nov94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
     F*  CPK008 - DBA R2 packaging:                                   *
     F*           - Increase length of #SRCMBRI file to 112 and amend *
     F*             associated fields to match new file length.       *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*CGGSETL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F*CGGSASL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F*CGRASCL1* IF   E           K DISK                                                    MD054955
     F*********                            INFSR(SRFILE)                                    MD054955
     F*CGRDTAL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
     F#SRCMBRI  IF   E             DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(CGCPYSRC:INPFMT)
     F#SRCMBRO  O    E             DISK    USROPN
     F                                     INFSR(SRFILE)
     F                                     RENAME(#SRCMBRO:OUTFMT)
     D/EJECT
     D*
     D*  Array containing Copyright statement
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D MBR@            S             11    DIM(18) CTDATA PERRCD(1)
     D**********          #D         80  1               CPK008
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D*  Copysource for error processing
     D*
     D CGGSAS        E DS                  EXTNAME(CGGSAJW0)                                MD054955
     D CGGSET        E DS                  EXTNAME(CGSETJW0)                                MD054955
     D CGRASC        E DS                  EXTNAME(CGRASJW0)                                MD054955
     D CGRDTA        E DS                  EXTNAME(CGRDTJW0)                                MD054955
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D*  End of Program Error Processing copysource
     D*
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D*                                                                   S01194
     D* Data Structures used by Access Programs                           S01194
     D*                                                                   S01194
      *
     D                 DS
     D  Z1                     1      4  0
     D  Z2                     5      8  0
     D  Z3                     9     12  0
     D  Z4                    13     16  0
     D  Z5                    17     20  0
      *
     D                 DS
     D  L1                     1      4  0
     D  L2                     5      8  0
     D  L3                     9     12  0
     D  L4                    13     16  0
     D  L5                    17     20  0
      *
     D U@              C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ@')
      *
     D L@              C                   CONST('abcdefghijklmnopqrst-
     D                                     uvwxyz_')
      *
     D WKDQ1           C                   CONST('GEXSTACK  ')
     D WKDQ2           C                   CONST('GEXSTORE  ')
     D WKDQ3           C                   CONST('GEXFSPEC  ')
     D WKDQ4           C                   CONST('GEXEXSEQ  ')
     D LIBL            C                   CONST('*LIBL')
     D ERRMSG          C                   CONST('CGD1811')
      *
     D SYSGRS          C                   CONST('SYSTEM')
      *
     D                 DS
     D  WKDL1                  1      2P 0 INZ(6)
     D  WKDL2                  3      4P 0 INZ(1)
     D  WKDK2                  5      6P 0 INZ(6)
     D  WKDL3                  7      8P 0 INZ(10)
     D  WKDK3                  9     10P 0 INZ(10)
     D  WKDL4                 11     12P 0 INZ(6)
     D  WKDK4                 13     14P 0 INZ(5)
      *
     D ST1DS           DS
     D  ST1DS1                 1      6
      *
     D ST2DS           DS
     D  ST2DS1                 1      6
      *
     D ST3DS           DS
     D  ST3DS1                 1     10
      *
     D ST4DS           DS
     D  ST4DS1                 1      1
     D  ST4DS2                 2      2
     D  ST4DS3                 3      5
      *
     D #LINE           DS
     D  #RCSEQ                 1      6  2 INZ(1)
     D  #RCDAT                 7     12  0
     D**********                             13  92 #RCDTA                CPK008
     D**********                             13  92 #D                    CPK008
     D  #RCDTA                13    112                                         CPK008
     D  #D                    13    112                                         CPK008
     D                                     DIM(100)                             CPK008
     D  #CSPEC                18     18    INZ('C')
      *
     D LINE            DS
     D  SRCSEQ                 1      6  2
     D  SRCDAT                 7     12  0
     D**********                             13  92 SRCDTA                CPK008
     D  SRCDTA                13    112                                         CPK008
      *
     D MBRDS           DS
     D  #MBR                   1     10
     D  #SEQ                  11     11
      *
     D  ZADFMF                 1     10    INZ('CGUSRMSG')
      *
     D CMDS11          C                   CONST('OVRDBF FILE(#SRCMBRI-
     D                                     ) TOFILE(CGCPYSRC)  -
     D                                     MBR(')
     D CMDS12          C                   CONST(')')
      *
     D SRCL00          C                   CONST('CLEAR')
     D SRCL01          C                   CONST('EXSR')
     D SRCL02          C                   CONST('0         R1      30')
     D SRCL03          C                   CONST('ADD  1         R1')
     D SRCL04          C                   CONST('Z-ADD')
     D SRCL05          C                   CONST('MOVEL')
     D SRCL06          C                   CONST('MOVE')
     D SRCL07          C                   CONST('SUBST')
     D SRCL08          C                   CONST('CAT')
     D SRCL09          C                   CONST('R#DATA')
     D SRCL10          C                   CONST('##DATA')
     D SRCL11          C                   CONST('##DCPA')
     D SRCL12          C                   CONST('##R,R1')
     D SRCL13          C                   CONST('##D,R1')
     D SRCL14          C                   CONST('R#DEFN')
     D SRCL15          C                   CONST('#@RDE')
     D SRCL16          C                   CONST('##RDE')
     D SRCL17          C                   CONST('##RDEC')
     D SRCL18          C                   CONST('##RDET')
     D SRCL19          C                   CONST('##RDED')
     D SRCL97          C                   CONST('''')
     D SRCL98          C                   CONST('EXSR SRADTA')
     D SRCL99          C                   CONST('EXSR SRODTA')
     D SRCLFS          C                   CONST('F        IF  E      -
     D                                          K        DISK  -
     D                                            KINFSR SRFILE')
      *
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *X
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     ST1DS1        PARM                    P0GRP             6
      *
     C     STINZ1        PLIST
     C                   PARM      WKDQ1         QNAME            10
     C                   PARM      LIBL          LIB              10
      *
     C     STINZ2        PLIST
     C                   PARM      WKDQ2         QNAME            10
     C                   PARM      LIBL          LIB              10
      *
     C     STINZ3        PLIST
     C                   PARM      WKDQ3         QNAME            10
     C                   PARM      LIBL          LIB              10
      *
     C     STINZ4        PLIST
     C                   PARM      WKDQ4         QNAME            10
     C                   PARM      LIBL          LIB              10
      *
     C     STPUSH        PLIST
     C                   PARM      WKDQ1         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM      WKDL1         FLDLEN            5 0
     C                   PARM      ST1DS         STACK
      *
     C     STPOP         PLIST
     C                   PARM      WKDQ1         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM                    FLDLEN            5 0
     C     ST1DS         PARM                    STACK
     C                   PARM      0             WAIT              5 0
      *
     C     *LIKE         DEFINE    ST1DS         STACK
      *
     C     STSTOR        PLIST
     C                   PARM      WKDQ2         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM      WKDL2         FLDLEN            5 0
     C                   PARM                    DUMMY1            1
     C                   PARM      WKDK2         KEYLEN            3 0
     C                   PARM      ST2DS         KEYVAL
      *
     C     STPULL        PLIST
     C                   PARM      WKDQ2         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM                    FLDLEN            5 0
     C                   PARM                    DUMMY1            1
     C                   PARM      0             WAIT              5 0
     C                   PARM      'EQ'          KEYORD            2
     C                   PARM      WKDK2         KEYLEN            3 0
     C                   PARM      ST2DS         KEYVAL
     C                   PARM      0             SNDLEN            3 0
     C                   PARM                    SNDR             44
      *
     C     *LIKE         DEFINE    ST2DS         KEYVAL
      *
     C     STSTO3        PLIST
     C                   PARM      WKDQ3         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM      WKDL3         FLDLEN            5 0
     C                   PARM      ST3DS         DTAVA3
     C                   PARM      WKDK3         KEYLEN            3 0
     C                   PARM      ST3DS         KEYVA3
      *
     C     STPUL3        PLIST
     C                   PARM      WKDQ3         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM                    FLDLEN            5 0
     C                   PARM                    DTAVA3
     C                   PARM      0             WAIT              5 0
     C                   PARM      'EQ'          KEYORD            2
     C                   PARM      WKDK3         KEYLEN            3 0
     C                   PARM      ST3DS         KEYVA3
     C                   PARM      0             SNDLEN            3 0
     C                   PARM                    SNDR             44
      *
     C     STRCV3        PLIST
     C                   PARM      WKDQ3         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM                    FLDLEN            5 0
     C     ST3DS         PARM                    DTAVA3
     C                   PARM      0             WAIT              5 0
     C                   PARM      'GE'          KEYORD            2
     C                   PARM      WKDK3         KEYLEN            3 0
     C                   PARM      *BLANKS       KEYVA3
     C                   PARM      0             SNDLEN            3 0
     C                   PARM                    SNDR             44
      *
     C     *LIKE         DEFINE    ST3DS         DTAVA3
     C     *LIKE         DEFINE    ST3DS         KEYVA3
      *
     C     STSTO4        PLIST
     C                   PARM      WKDQ4         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM      WKDL4         FLDLEN            5 0
     C                   PARM      GALGST        DTAVA4
     C                   PARM      WKDK4         KEYLEN            3 0
     C                   PARM      ST4DS         KEYVA4
      *
     C     STPUL4        PLIST
     C                   PARM      WKDQ4         QNAME            10
     C                   PARM      LIBL          LIB              10
     C                   PARM                    FLDLEN            5 0
     C     GALGST        PARM                    DTAVA4
     C                   PARM      0             WAIT              5 0
     C                   PARM      'GE'          KEYORD            2
     C                   PARM      WKDK4         KEYLEN            3 0
     C                   PARM      *BLANKS       KEYVA4
     C                   PARM      0             SNDLEN            3 0
     C                   PARM                    SNDR             44
      *
     C     *LIKE         DEFINE    GALGST        DTAVA4
     C     *LIKE         DEFINE    ST4DS         KEYVA4
      *
     C     KEYL01        KLIST
     C                   KFLD                    GSGRPS
      *
     C     KEYL02        KLIST
     C                   KFLD                    GAFGST
      *
     C     KEYL03        KLIST
     C                   KFLD                    RAGRPS
      *
     C     KEYL04        KLIST
     C                   KFLD                    RDRDE
      *
      *  Reset return code
      *
     C                   MOVEL     *BLANKS       P0RTN
      *  Initialise line date
     C                   RESET                   #LINE
     C                   Z-ADD     ##EDT         #RCDAT
      *  Clear stack
     C                   CALL      'QCLRDTAQ'    STINZ1
      *  Clear stack
     C                   CALL      'QCLRDTAQ'    STINZ2
      *  Clear stack
     C                   CALL      'QCLRDTAQ'    STINZ3
      *  Clear stack
     C                   CALL      'QCLRDTAQ'    STINZ4
      *
     C                   OPEN      #SRCMBRO
      *
      *  Generate Header source lines
      *
     C                   MOVE      'H'           @SEQ
     C                   EXSR      SR#MBR
      *  Increment for F specs
     C     *LIKE         DEFINE    #RCSEQ        @RCSEQ
     C                   Z-ADD     #RCSEQ        @RCSEQ
     C                   ADD       256           #RCSEQ
      *
      *  Generate E & I spec source lines
      *
     C                   MOVE      'C'           @SEQ
     C     L@:U@         XLATE     ST1DS1        U#GRPS
     C                   EXSR      SR#MBR
      *
      *  DOU Stack Pull End
      *
     C     FLDLEN        DOUEQ     0
      *
      *  First check if subroutine already generated
      *
     C                   MOVE      ST1DS1        ST2DS1
     C                   CALL      'QRCVDTAQ'    STPULL
      *
     C     FLDLEN        IFEQ      0
      *
     C                   MOVE      ST1DS1        GSGRPS
     C*****KEYL01        CHAIN     @GSETL1                            01                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :GSGRPS and GSRECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
      *
     C     *LIKE         DEFINE    GSGRPS        U#GRPS
     C     L@:U@         XLATE     GSGRPS        U#GRPS
      *
     C                   MOVE      'B'           @SEQ
     C                   EXSR      SR#MBR
      *
     C     GSCSET        IFNE      'T'
     C     GSMREC        ANDEQ     'Y'
     C                   MOVE      'R'           @SEQ
     C                   EXSR      SR#MBR
     C                   END
      *
     C                   MOVE      GSGRPS        GAFGST
     C*****KEYL02        CHAIN     @GSASL1                            02                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGGSAJW0                                                              MD054955
     C+ where GAFGST = :GAFGST and GARECI = 'D'                                             MD054955
     C+ order by GAFGST, GALGST                                                             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ACursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       02                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        02                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
     C     *IN02         IFEQ      *ON
     C                   EXSR      SR#RDE
     C                   END
      *
     C     *IN02         DOWEQ     *OFF
      *
     C     GALGST        IFNE      SYSGRS
      *
     C                   MOVE      GALGST        ST1DS1
     C                   CALL      'QSNDDTAQ'    STPUSH
      *
     C                   MOVE      GALGST        GSGRPS
     C*****KEYL01        CHAIN     @GSETL1                            01                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :GSGRPS and GSRECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
      *
     C                   MOVE      GSMREC        ST4DS1
     C                   MOVE      GSCSET        ST4DS2
     C                   MOVE      GASEQA        ST4DS3
     C                   CALL      'QSNDDTAQ'    STSTO4
      *
     C                   END
      *
     C*****KEYL02        READE     @GSASL1                                02                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       02                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        02                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C                   END
      *
     C                   CALL      'QRCVDTAQ'    STPUL4
      *
     C     FLDLEN        DOWNE     0
      *
     C                   EXSR      SREXSR
      *
     C                   CALL      'QRCVDTAQ'    STPUL4
     C                   END
      *
     C                   MOVE      'E'           @SEQ
     C                   EXSR      SR#MBR
      *
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    STSTOR
     C                   CALL      'QRCVDTAQ'    STPOP
      *
     C                   END
      *
      *  Generate Trailer source lines
      *
     C                   MOVE      'F'           @SEQ
     C                   EXSR      SR#MBR
      *
      *  Generate F Specs at end with correct sequence
      *
     C                   Z-ADD     @RCSEQ        #RCSEQ
      *
     C                   EXSR      SRFLIN
      *
     C                   CLOSE     #SRCMBRO
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Return to calling program
      *
     C                   RETURN
     C/EJECT
     C     *INZSR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     '*INZSR'      @STK(Q)
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      *  Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Put DTAQ into QTEMP for use as stack
      *
     C                   CALL      'CGC3002'                            9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      WKDQ1         P@DTAQ           10
     C                   PARM      WKDL1         P@DTAL            3 0
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CGC3002'     W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'CGD1741'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Put DTAQ into QTEMP for use as store
      *
     C                   CALL      'CGC3005'                            9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      WKDQ2         P@DTAQ           10
     C                   PARM      WKDL2         P@DTAL            3 0
     C                   PARM      WKDK2         P@KEYL            3 0
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CGC3005'     W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'CGD1741'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Put DTAQ into QTEMP for use as store
      *
     C                   CALL      'CGC3005'                            9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      WKDQ3         P@DTAQ           10
     C                   PARM      WKDL3         P@DTAL            3 0
     C                   PARM      WKDK3         P@KEYL            3 0
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CGC3005'     W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     4             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'CGD1741'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   CALL      'CGC3005'                            9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      WKDQ4         P@DTAQ           10
     C                   PARM      WKDL4         P@DTAL            3 0
     C                   PARM      WKDK4         P@KEYL            3 0
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'CGC3005'     W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     5             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'CGD1741'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   CLEAR                   GSGRPS
     C                   MOVE      '#'           GSGRPS
     C     '#'           SCAN      GSGRPS        P1                3 0
      *
     C                   CLEAR                   GSDESC
     C                   MOVE      '#'           GSDESC
     C     '#'           SCAN      GSDESC        P2                3 0
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SR#MBR   : Generate Header Source Lines                      *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 010                                               *
      *                                                               *
      *****************************************************************
     CSR   SR#MBR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SR#MBR'      @STK(Q)
      *
     C                   DO        18            L1
      *
     C                   MOVE      MBR@(L1)      MBRDS
      *
     C     #SEQ          IFEQ      @SEQ
     C                   EXSR      SRLMBR
     C                   END
      *
     C                   END
      *
     C     *LIKE         DEFINE    #SEQ          @SEQ
     C                   CLEAR                   @SEQ
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRLMBR   : Generate Source lines from member                 *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 020                                               *
      *                                                               *
      *****************************************************************
     CSR   SRLMBR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRLMBR'      @STK(Q)
      *
     C                   MOVEL(P)  CMDS11        CMDSTR
     C     CMDSTR        CAT(P)    #MBR:0        CMDSTR
     C     CMDSTR        CAT(P)    CMDS12:0      CMDSTR
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMDSTR          256
     C                   PARM      256           CMDLEN           15 5
      *
     C                   OPEN      #SRCMBRI
     C                   READ      #SRCMBRI                               05
      *
     C     *IN05         DOWEQ     *OFF
      *
     C                   MOVE      SRCDTA        #RCDTA
      *
     C                   SELECT
     C     @SEQ          WHENNE    'F'
      *  Scan for U#GRPS,L#GRPS & #SDESC for substitution
     C     'U#GRPS'      SCAN      #RCDTA        Z1                       30
      *
     C     *IN30         IFEQ      *ON
      *
     C                   MOVEA     U#GRPS        #D(Z1)
      *
     C                   END
      *
     C     'L#GRPS'      SCAN      #RCDTA        Z1                       30
      *
     C     *IN30         IFEQ      *ON
      *
     C                   MOVEA     GSGRPS        #D(Z1)
      *
     C                   END
      *
     C     '#SDESC'      SCAN      #RCDTA        Z1                       30
      *
     C     *IN30         IFEQ      *ON
      *
     C                   MOVEA     GSDESC        #D(Z1)
      *
     C                   END
      *
     C                   ENDSL
      *
     C                   EXSR      SRLINE
      *
     C                   READ      #SRCMBRI                               05
     C                   END
      *
     C                   CLOSE     #SRCMBRI
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRLINE   : Generate Source Line                              *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 030                                               *
      *                                                               *
      *****************************************************************
     CSR   SRLINE        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRLINE'      @STK(Q)
      *
     C                   ADD       1             #RCSEQ
     C                   MOVE      #LINE         LINE
     C                   WRITE     OUTFMT
     C                   RESET                   #RCDTA
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SR#RDE   : Generate Source for non repeating GSs             *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 040                                               *
      *                                                               *
      *****************************************************************
     CSR   SR#RDE        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SR#RDE'      @STK(Q)
      *
     C                   MOVE      ST1DS1        RAGRPS
     C                   Z-ADD     1             #C                3 0
      *
     C*****KEYL03        CHAIN     @RASCL1                            03                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare RCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGRASJW0                                                              MD054955
     C+ where RAGRPS = :RAGRPS and RARECI = 'D'                                             MD054955
     C+ order by RAGRPS, RARDE                                                              MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open RCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from RCursor into :CGRASC                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN03         DOWEQ     *OFF                                                     MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
      *
     C     #C            IFEQ      21
      *
     C                   MOVEA     '*'           #D(7)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL98        #D(28)
     C                   EXSR      SRLINE
      *
     C                   Z-ADD     1             #C                3 0
     C                   END
      *
     C     #C            IFEQ      1
     C                   MOVEA     SRCL04        #D(28)
     C                   MOVEA     SRCL02        #D(33)
     C                   EXSR      SRLINE
     C                   END
      *
     C                   MOVE      RARDE         RDRDE
     C*****KEYL04        CHAIN     @RDTAL1                            04                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :RDRDE and RDRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       04                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        04                    MD054955
     C                   ENDIF                                                              MD054955
      *
     C                   EXSR      SRFGEN
      *
     C                   MOVEA     '*'           #D(7)
     C                   MOVEA     RDDESC        #D(9)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL03        #D(28)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL00        #D(28)
     C                   MOVEA     SRCL09        #D(33)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL00        #D(28)
     C                   MOVEA     SRCL14        #D(33)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL00        #D(28)
     C                   MOVEA     SRCL15        #D(33)
     C                   EXSR      SRLINE
      *
     C     2             SUBST     RDRDE:9       WRK2A             2
     C     8             SUBST     RDRDE:1       WRK8A             8
      *
     C     WRK2A         IFNE      *BLANKS
      *
     C                   MOVEA     SRCL06        #D(28)
     C                   MOVEA     SRCL97        #D(33)
     C                   MOVEA     WRK2A         #D(34)
     C                   MOVEA     SRCL97        #D(36)
     C                   MOVEA     SRCL15        #D(43)
     C                   EXSR      SRLINE
      *
     C                   END
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     SRCL97        #D(33)
     C                   MOVEA     WRK8A         #D(34)
     C                   MOVEA     SRCL97        #D(42)
     C                   MOVEA     SRCL15        #D(43)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL16        #D(18)
     C                   MOVEA     SRCL08        #D(28)
     C                   MOVEA     SRCL15        #D(33)
     C     #RCDTA        CAT       ':1':0        #RCDTA
     C                   MOVEA     SRCL16        #D(43)
     C                   EXSR      SRLINE
      *
     C     RDELYP        IFEQ      '*DEC'
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     RDDINT        #D(33)
     C                   MOVEA     SRCL10        #D(43)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL05        #D(28)
     C     6             SUBST     RDFOPT        WRK6A             6
     C                   MOVEA     SRCL97        #D(33)
     C                   MOVEA     WRK6A         #D(34)
     C                   MOVEA     SRCL97        #D(40)
     C                   MOVEA     SRCL17        #D(43)
     C                   EXSR      SRLINE
      *
     C                   SELECT
     C     WRK6A         WHENEQ    'Amount'
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     SRCL97        #D(33)
     C                   MOVEA     'L'           #D(34)
     C                   MOVEA     SRCL97        #D(35)
     C                   MOVEA     SRCL18        #D(43)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     '##CCY'       #D(43)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL01        #D(28)
     C                   MOVEA     'SRDCDT'      #D(33)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     'A6NBDP'      #D(33)
     C                   MOVEA     SRCL11        #D(43)
     C                   EXSR      SRLINE
      *
     C     WRK6A         WHENEQ    'Rate  '
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     SRCL97        #D(33)
     C                   MOVEA     'L'           #D(34)
     C                   MOVEA     SRCL97        #D(35)
     C                   MOVEA     SRCL18        #D(43)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     SRCL97        #D(33)
     C                   MOVEA     '7'           #D(34)
     C                   MOVEA     SRCL97        #D(35)
     C                   MOVEA     SRCL11        #D(43)
     C                   EXSR      SRLINE
      *
     C     WRK6A         WHENEQ    'Xrate '
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     SRCL97        #D(33)
     C                   MOVEA     'L'           #D(34)
     C                   MOVEA     SRCL97        #D(35)
     C                   MOVEA     SRCL18        #D(43)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     SRCL97        #D(33)
     C                   MOVEA     '8'           #D(34)
     C                   MOVEA     SRCL97        #D(35)
     C                   MOVEA     SRCL11        #D(43)
     C                   EXSR      SRLINE
      *
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     RDDINT        #D(33)
     C                   MOVEA     SRCL09        #D(43)
     C                   EXSR      SRLINE
      *
     C                   END
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     SRCL09        #D(33)
     C                   MOVEA     SRCL13        #D(43)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL05        #D(28)
     C                   MOVEA     SRCL14        #D(33)
     C                   MOVEA     SRCL12        #D(43)
     C                   EXSR      SRLINE
      *
     C                   ADD       1             #C
      *
     C*****KEYL03        READE     @RASCL1                                03                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from RCursor into :CGRASC                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   END
      *
     C                   MOVEA     '*'           #D(7)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL98        #D(28)
     C                   EXSR      SRLINE
      *
     C                   MOVEA     SRCL99        #D(28)
     C                   EXSR      SRLINE
      *
     C/EXEC SQL                                                                             MD054955
     C+ close RCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SREXSR   : Generate Source line for EXSR GSname              *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 050                                               *
      *                                                               *
      *****************************************************************
     CSR   SREXSR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SREXSR'      @STK(Q)
      *
     C     L@:U@         XLATE     GALGST        U#GRPS
      *
     C                   MOVEA     SRCL01        #D(28)
      *
     C                   Z-ADD     33            Z1
      *
     C                   DO        P1            Z2
     C     1             SUBST     U#GRPS:Z2     #D(Z1)
     C                   ADD       1             Z1
     C                   END
      *
     C                   EXSR      SRLINE
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFGEN   : Generate F spec entries in DTAQ                   *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 060                                               *
      *                                                               *
      *****************************************************************
     CSR   SRFGEN        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFGEN'      @STK(Q)
      *
     C     RDDSRC        IFNE      *BLANKS
      *
     C                   MOVE      RDDSRC        ST3DS1
      *
     C                   CALL      'QRCVDTAQ'    STPUL3
     C                   CALL      'QSNDDTAQ'    STSTO3
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFLIN   : Generate F spec line from RDE data                *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *  OFFSET   : 070                                               *
      *                                                               *
      *****************************************************************
     CSR   SRFLIN        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFLIN'      @STK(Q)
      *
     C                   CALL      'QRCVDTAQ'    STRCV3
      *
     C     FLDLEN        DOWNE     0
      *
     C                   MOVEA     SRCLFS        #D(6)
     C     8             SUBST     ST3DS1        WRK8A
     C                   MOVEA     WRK8A         #D(7)
      *
     C                   EXSR      SRLINE
      *
     C                   CALL      'QRCVDTAQ'    STRCV3
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
**  CPY@
(c) Finastra International Limited 2001
**  MBR@
CG4HDR    H
CG4ESS    C
CG4ISS    C
CG4MAIN   C
CG4BEGS   B
CG4BEGR   R
CG4ENDS   E
CG4INZ    F
CG4INIT   F
CG4ADTA   F
CG4ODTA   F
CG4BIND   F
CG4PATH   F
CG4RFMN   F
CG4DCDT   F
CG4GENR   F
CG4COPY   F
CG4#ARR   F
