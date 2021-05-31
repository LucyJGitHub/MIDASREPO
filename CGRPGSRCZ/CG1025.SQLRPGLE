     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Validate group set parameters.')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                  *
     F*                                                               *
     F*  CG1025  - - - - Validate group set parameters.               *
     F*                                                               *
     F*  Function:   - - This program accepts the entries made on     *
     F*                   the group set amendment screen (CG1030),    *
     F*                   and validates them. If any errors are       *
     F*                   found, an appropriate message ID is         *
     F*                   returned in parameter P0RTN.                *
     F*                                                               *
     F*  Called By: CG1030 (Amend group set)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 084569             Date 10Mar95               *
      *                 S01522             Date 01Jan95               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  084569 - Provide additional validation                       *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*  90 -- Error detected.                                        *
     F*  91 -- No records for this group set -- CGRASCL1.             *
     F*  92 -- No records for this group set -- CGGSASL0.             *
     F*  93 -- End of file reached for this group set -- CGGSASL3.    *
     F*  94 -- No records for this group set -- CGGSETL0.             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Subroutine usage                                             *
     F*  ~~~~~~~~~~~~~~~~                                             *
     F*  SRCSI  -- Validate the complex set indicator.                *
     F*  SRMI   -- Validate the multiple indicator.                   *
     F*  SRGSD  -- Validate the group set definition.                 *
     F*  SRINIT -- Provide initialisation and definitions.            *
     F*                                                               *
     F*  Copied-in routines:                                          *
     F*                                                               *
     F*  *PSSR  -- Program error routine.                             *
     F*  SRFILE -- File error routine.                                *
     F*  SRERR  -- Error reporting routine.                           *
     F*                                                               *
     F*****************************************************************
     F/SPACE
     F*-------------------------------------------------------------------
     F* Copied-in file definitions:
     F*
     F/COPY WNCPYSRC,CG1025FPG
     F*===================================================================
     F*CGRASCL1  IF   E           K DISK    INFSR(SRFILE)                                   MD054955
     F* RDE association table
     F*-------------------------------------------------------------------
     F*CGGSASL1* IF   E           K DISK    INFSR(SRFILE)                                   MD054955
     F* Group set association table -- keyed by From group set
     F*-------------------------------------------------------------------
     F*CGGSASL3* IF   E           K DISK    INFSR(SRFILE)                                   MD054955
     F* Group set association table -- keyed by Linked group set
     F*-------------------------------------------------------------------
     F*CGGSETL1  IF   E           K DISK    INFSR(SRFILE)                                   MD054955
     F* Group set definitions
     F*-------------------------------------------------------------------
     D/EJECT
     D*-------------------------------------------------------------------
     D* Error processing array:
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D*
     D* Copied-in array definitions:
     D*
     D/COPY WNCPYSRC,CG1025EPG
     D*
     D*-------------------------------------------------------------------
     D/SPACE
     D*-------------------------------------------------------------------
     D/COPY WNCPYSRC,CG1025IPG
     D*
     D* Copied-in data structures
     D*
     D*...................................................................
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)
     D CGGSAS        E DS                  EXTNAME(CGGSAJW0)                                MD054955
     D CGGSET        E DS                  EXTNAME(CGSETJW0)                                MD054955
     D CGRASC        E DS                  EXTNAME(CGRASJW0)                                MD054955
      *COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D* Error processing data structures
     D*
     D*...................................................................
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)
     D  WCMTNO       E                     EXTFLD(COMITNUM)
     D  WJOB01       E                     EXTFLD(COMITJOB1)
     D  WJOB02       E                     EXTFLD(COMITJOB2)
     D  WJOB03       E                     EXTFLD(COMITJOB3)
     D  WJOB04       E                     EXTFLD(COMITJOB4)
     D  WJOB05       E                     EXTFLD(COMITJOB5)
     D  WJOB06       E                     EXTFLD(COMITJOB6)
     D  WJOB07       E                     EXTFLD(COMITJOB7)
     D  WJOB08       E                     EXTFLD(COMITJOB8)
     D  WJOB09       E                     EXTFLD(COMITJOB9)
     D  WJOB10       E                     EXTFLD(COMITJOB10)
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D P0PARM          DS
     D*
     D* The P0PARM data structure passes group set details
     D*  to this program, as follows:
     D*
     D*  > P0GSET -- the group set name;
     D*  > P0CSI  -- the complex set indicator;
     D*  > P0MI   -- the multiple indicator;
     D*  > P0RSI  -- the restricted set indicator; and
     D*  > P0MMG  -- the mail merge group flag.
     D*
     D  P0GSET                 1      6
     D  P0CSI                  7      7
     D  P0MI                   8      8
     D  P0RSI                  9      9
     D  P0MMG                 10     10
     D*...................................................................
     D* Named constants:
     D*
     D* #MSG01 -- Message identifier for error 1 --
     D*           Records were found for this group set
     D*            on the RDE association table
     D*            (complex set indicator is T or Y)
     D*
     D* #MSG02 -- Message identifier for error 2 --
     D*           Records were found for this group set
     D*            on the group set association table
     D*            (complex set indicator is N)
     D*
     D* #MSG03 -- Message identifier for error 3 --
     D*           Records were found for this group set
     D*            on the RDE association table
     D*            (multiple indicator is T or Y)
     D*
     D* #MSG04 -- Message identifier for error 4 --
     D*           A record was found for a parent group set
     D*            in the group sets definitions file
     D*            with a multiple indicator of "N" (No)
     D*            (multiple indicator is Y)
     D*
     D #MSG01          C                   CONST('CGD1831')
     D #MSG02          C                   CONST('CGD1832')
     D #MSG03          C                   CONST('CGD1833')
     D #MSG04          C                   CONST('CGD1834')
     I*
     I* Note: this list must be kept matched with the similar list in
     I*       program CG1030, since it is used to select which item
     I*       is highlighted as being in error.
     I********************************************************************
     C/EJECT
     C********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P0PARM           10
     C                   PARM                    P0PGM            10
     C*
     C* Add subroutine name to stack:
     C*
     C                   Z-ADD     1             Q
     C                   MOVEL     '@Main@'      @STK(Q)
     C*
     C* Initialise:
     C                   EXSR      SRINIT
     C*
     C* Validate the complex set indicator (P0CSI):
     C*
     C                   EXSR      SRCSI
     C*
     C* Validate the multiple indicator (P0MI):
     C*
     C     P0RTN         IFEQ      *BLANKS
     C                   EXSR      SRMI
     C                   ENDIF
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   RETURN
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRCSI validates the complex set indicator.         **
     C********************************************************************
     C     SRCSI         BEGSR                                                  * S R C S I   *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRCSI '      @STK(Q)
     C*
     C* If the complex set indicator is "T" (Top-level)
     C*                              or "Y" (Yes),
     C*  there must be no records for this group set
     C*  in the RDE association table:
     C*
     C     P0CSI         IFEQ      'T'
     C     P0CSI         OREQ      'Y'
     C*****P0GSET        CHAIN     CGRASCL1                           91                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRASC                                                                        MD054955
     C+ from CGRASJW0                                                                       MD054955
     C+ where RAGRPS = :P0GSET and RARECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       91                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN91         IFEQ      *OFF
     C                   MOVE      #MSG01        P0RTN
     C                   ENDIF
     C                   ENDIF
     C*
     C* If the complex set indicator is "N" (No),
     C*  there must be no records for this group set
     C*  in the group set association table:
     C*
     C     P0CSI         IFEQ      'N'
     C*****P0GSET        CHAIN     CGGSASL1                           92                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSAS                                                                        MD054955
     C+ from CGGSAJW0                                                                       MD054955
     C+ where GAFGST = :P0GSET and GARECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       92                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        92                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN92         IFEQ      *OFF
     C                   MOVE      #MSG02        P0RTN
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXCSI         TAG                                                    <<<=== EXCSI
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRMI validates the multiple indicator.             **
     C********************************************************************
     C     SRMI          BEGSR                                                  * S R M I     *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRMI  '      @STK(Q)
     C*
     C* If the multiple indicator is "T" (Top-level)
     C*                           or "Y" (Yes),
     C*  there must be no records for this group set
     C*  in the RDE association table:
     C*
     C     P0MI          IFEQ      'T'
     C     P0MI          OREQ      'Y'
     C*****P0GSET        CHAIN     CGRASCL1                           91                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRASC                                                                        MD054955
     C+ from CGRASJW0                                                                       MD054955
     C+ where RAGRPS = :P0GSET and GARECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       91                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN91         IFEQ      *OFF
     C                   MOVE      #MSG03        P0RTN
     C                   ENDIF
     C                   ENDIF
     C*
     C* If the multiple indicator is "Y" (Yes)
     C*   and there is no error up to this point,
     C*  validate the group sets to which this group
     C*   set is linked (the parent group sets):
     C*
     C     P0MI          IFEQ      'Y'
     C     P0RTN         ANDEQ     *BLANKS
     C                   EXSR      SRGSD
     C                   ENDIF
     C*
     C     EXMI          TAG                                                    <<<=== EXMI
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRGSD validates the group set definition.          **
     C********************************************************************
     C     SRGSD         BEGSR                                                  * S R G S D   *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRGSD '      @STK(Q)
     C*
     C* Find the parent group sets for the current group set:
     C*
     C*****P0GSET        SETLL     CGGSASL3                                                 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare BCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGGSAJW0                                                              MD054955
     C+ where GALGST = :P0GSET and GARECI = 'D'                                             MD054955
     C+ order by GALGST, GAFGST                                                             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open BCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C*
     C     *IN93         DOUEQ     *ON
     C     P0RTN         ORNE      *BLANKS
     C*****P0GSET        READE     CGGSASL3                               93                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from BCursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       93                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        93                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN93         IFEQ      *OFF
     C*
     C* If a parent group set has a multiple indicator of "N" (No),
     C*  note this as an error:
     C*
     C*****GAFGST        CHAIN     CGGSETL1                           94
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :GAFGST and GSRECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       94                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        94                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN94         IFEQ      *OFF
     C     GSMREC        ANDEQ     'N'
     C                   MOVE      #MSG04        P0RTN
     C                   ENDIF
     C*
     C                   ENDIF
     C                   ENDDO
     C*
     C/EXEC SQL                                                                             MD054955
     C+ close BCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
     C     EXGSD         TAG                                                    <<<=== EXGSD
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRINIT provides initialisation.                    **
     C********************************************************************
     C     SRINIT        BEGSR                                                  * S R I N I T *
     C*
     C* Add subroutine name to stack:
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
     C*
     C* Define and clear error return code:
     C*
     C                   MOVE      *BLANKS       P0RTN
     C*
     C* Move the copyright parameter:
     C*
     C                   MOVEA     CPY@          ACT@             80
     C*
     C     EXINIT        TAG                                                    <<<=== EXINIT
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSC022'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSC022
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
     C                   MOVE      'N'           WCMTSK
      *                                                                                       CSC022
     C                   IN        WDSJOB
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0
     C                   MOVEA     WCJOBS        WCMT
     C                   Z-ADD     1             I                 2 0
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                51
     C     *IN51         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSC022
     C                   ELSE
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     21            W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CSC022
     C************NAMVAR   DEFN           WDSJOB                                       CSC022BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB
      *                                                                                       CSC022
     C                   ENDIF
      *                                                                                       CSC022
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C** Subroutine *PSSR handles program errors.                       **
     C********************************************************************
     C*
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C* /Copy point for calculation specifications:
     C*
     C/COPY WNCPYSRC,CG1025CPG
     C*
     C********************************************************************
     O/EJECT
     O********************************************************************
     C* /Copy point for output:
     C*
     O/COPY WNCPYSRC,CG1025DOPG
     C*
     O********************************************************************
** CPY@ -- Copyright statement.
(c) Finastra International Limited 2001
