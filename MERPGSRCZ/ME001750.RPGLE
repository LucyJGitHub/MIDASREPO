     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME Outgoing Message Field Management')           *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME001740 - Midas ME Outgoing Message Field Management        *
      *                                                               *
      *  Function:  This program maintains the Outgoing Message Field *
      *             Management                                        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD034562           Date 02Jun15               *
      *                 CSW215             Date 06Apr15               *
      *                 CSW213             Date 03Jun13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 256637             Date 17Sep08               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21063           Date 15Sep08               *
      *                 CSW208             Date 15Apr08               *
      *                 BUG17503           Date 02Mar08               *
      *                 BUG15140           Date 18Oct07               *
      *                 250600             Date 04Oct07               *
      *                 BUG14042           Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CSW207             Date 15Jun07               *
      *                 BUG13798           Date 25Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032  *CREATE    Date 11Sep06               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034562 - ACOUNTLINE and ACOUNTIBAN must be accepted for    *
      *             59F even if CSW215 is OFF                         *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  256637 - OMFM validation error. Additional CSW08 changes.    *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  BUG21063 - OMFM validation error                             *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *  BUG17503 - MT101 generated in MGOMSGPD is not in 50F format  *
      *  BUG15140 - *FORMAT is accepted as a valid action even if     *
      *             CSW207 is off.                                    *
      *  250600 - Fix CFT032/CSW207                                   *
      *  CSW207 - SWIFT 2007 Standard Changes                         *
      *  BUG14042 - CFT032 errors ; applied fix 13798                 *
      *  BUG13798 - CFT032 errors                                     *
      *  CFT032 - Account line in field 50X in MT103                  *
      *                                                               *
      *****************************************************************
      *
      ** Midas ME Outgoing Message Filed Management
      *
     FME001750DFCF   E             WORKSTN
     F                                     SFILE(RSFLRCD:SRRN)
     F                                     SFILE(RSFLRC4:SRRN)                                CSW207
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)

      ** Midas ME Outgoing Message Field Management retrieval index

     FMEOUFML1  IF   E           K DISK
     F                                     INFSR(*PSSR)

      ** Midas ME Outgoing Message Field Management update index

     FMEOUFML0  UF A E           K DISK
     F                                     RENAME(@OUFMPD:@OUFMPDX0)
     F*                                    COMMIT
     F                                     INFSR(*PSSR)

     FMEOUFML7  UF   E           K DISK                                                       CSW207
     F                                     RENAME(@OUFMPD:@OUFMPDX7)                          CSW207
     F                                     INFSR(*PSSR)                                       CSW207
                                                                                              CSW207
      ** Copyright notice for inclusion in all programs

      ** Copyright array

     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)

      ** Program data structure

     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)

      ** Display file information data structure

     D INFDS#        E DS                  EXTNAME(Y2I#DSP)

      ** Local data area data structure

     D WLDA          E DS                  EXTNAME(LDA)

      ** Bank's data structure

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Long data structure

     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** SAR Details Accessed via access program

     D DSSDY         E DS                  EXTNAME(DSSDY)

     D DSLDY         E DS                  EXTNAME(DSLDY)

      ** Data structure for PF/MEISOCPD

     D WDBRC         E DS                  EXTNAME(MEISOCL0)

      ** Data structure for PF/SDMTPYPD

     D SDMTPY        E DS                  EXTNAME(SDMTPYPD)

      ** Data Structures for Network definition

     D DSNWRK        E DS                  EXTNAME(SDNWRKPD)

      ** Data Structures for Message Tag Definition

     D DSMTAG        E DS                  EXTNAME(SDMTAGPD)

      ** Country codes file format data structure

     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** Currency file format data structure

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Nostro location code file format data structure

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** Branch details file format data structure

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** Data structure used by access program

     D DSFDY         E DS                  EXTNAME(DSFDY)

     D ALPNUM          C                   CONST('ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZ1234567890')
     D FKEY1           C                   CONST('A=Amend       D=Delete       -
     D                                     E=Enquire')
     D FKEY2           C                   CONST('F3=Exit       F5=Refresh     -
     D                                     F9=Add       F11=Exception Report')
     D FKEY3           C                   CONST('F3=Exit')
     D FKEY4A          C                   CONST('F3=Exit                      -              CSW207
     D                                     F12-Previous')                                     CSW207
     D FKEY4B          C                   CONST('F3=Exit       F10-Delete     -              CSW207
     D                                     F12-Previous')                                     CSW207

     D W0RSF           S              1
     D WRRN            S              5  0
     D WCTR            S              5  0
     D WCTR2           S              5  0
     D WSPG            S              3  0
     D WSLIN           S              3  0
     D WKIND0          S              4
     D WERR            S              1
     D WNULL           S              1
     D WERROR          S              1
     D WFLDC           S              2
     D WSFPG           S              3  0
     D W0SLM           S              5  0
     D W0SPG           S              3  0
     D W0RR0           S              4  0
     D WSFLN           S              5  0
     D WF12            S              1
     D SRRN            S              5  0
     D PRTCD           S              7
     D POPTN           S              7
     D SMRDT           S              7
     D*** WOMCTRY         S              2                                                  BUG14042
     D WOMCTRY         S              4                                                     BUG14042
     D WSOMCURR        S              3
     D WINCLUDE        S              1
     D P0RTN           S              7
     D PMMODE          S              1
     D WTXTC1          S             80
     D WTXTC2          S             80
     D PMSGT           S             80
     D PMSGF           S             10
     D KE0286          S              7
     D KE0287          S             10
     D KE0288          S             80
     D PMSGID          S              7
     D WQ0286          S              7
     D WQ0287          S             10
     D WQ0288          S             80
     D WMODE           S              3
     D WQRYFLD         S              1
     D WRTNCD          S              7
     D WREPNM          S             10
     D WCOMNM          S             10
     D WCOMSQ          S              5
     D WCALLP          S            100
     D WMULTB          S              1
     D WLEVEL          S              1
     D WENTITY         S              3
     D WVAL1           S             10    INZ('0123456789')                                BUG14042
     D WVAL2           S              1                                                     BUG14042
     D CSW208          S              1A                                                      CSW208
     D CSW207          S              1A                                                      CSW207
     D WFAmend         S              1A                                                      CSW207
     D WFDelete        S              1A                                                      CSW207
     D WFEnquir        S              1A                                                      CSW207
     D PRtCde          S              7A                                                      CSW207
     D PAccount        S             34A                                                      CSW207
     D PInpTyp         S              1A                                                      CSW207
     D PCust           S              6A                                                      CSW207
     D PNonActH        S             10A                                                      CSW207
     D PVType          S              4A                                                      CSW207
     D PMsgeID         S              7A                                                      CSW207
     D PErrTyp         S              1A                                                      CSW207
     D PModInd         S              2A                                                      CSW207
     D POut1           S             35A                                                      CSW207
     D POut2           S             35A                                                      CSW207
     D POut3           S             35A                                                      CSW207
     D POut4           S             35A                                                      CSW207
     D POut5           S             35A                                                      CSW207
     D Arr5            S              1A   DIM(5)                                             CSW207
     D Idx             S              1  0                                                    CSW207
     D MAXREC          S              5  0 INZ(5)                                             CSW207
     D RECCTR          S              5  0                                                    CSW207
     D W50FS           S              3  0                                                    CSW207
     D UPDATEC         S              1                                                       CSW207
     D REM             S              1  0                                                    CSW207
     D WTERR           S              1                                                       CSW207
     D ERRSWC          S              5  0                                                    CSW207
     D CSW215          S              1A                                                      CSW215
     D CallFrom        S              4A                                                      CSW215
      *                                                                                       CSW207
      ***  50F Data structure                                                                 CSW207
     D SO50F           DS                                                                     CSW207
      *                                                                                       CSW207
     D SO50F1                  1     15A                                                      CSW207
     D SO50F2                 16     30A                                                      CSW207
     D SO50F3                 31     45A                                                      CSW207
     D SO50F4                 46     60A                                                      CSW207
     D SO50F5                 61     75A                                                      CSW207
      *                                                                                       CSW207
      ***  Compare Data structure 1                                                           CSW207
     D WCOMP1          DS                                                                     CSW207
      *                                                                                       CSW207
     D WTNWRK                  1      6A                                                      CSW207
     D WTMTPY                  7      9A                                                      CSW207
     D WTMTAG                 10     14A                                                      CSW207
     D WTSBRC                 15     18A                                                      CSW207
     D WTCTRY                 19     22A                                                      CSW207
     D WTCURR                 23     25A                                                      CSW207
     D WTNOST                 26     27A                                                      CSW207
     D WTACTI                 28     37A                                                      CSW207
      *                                                                                       CSW207
      ***  Compare Data structure 2                                                           CSW207
     D WCOMP2          DS                                                                     CSW207
      *                                                                                       CSW207
     D OMNWRK                  1      6A                                                      CSW207
     D OMMTPY                  7      9A                                                      CSW207
     D OMMTAG                 10     14A                                                      CSW207
     D OMSBRC                 15     18A                                                      CSW207
     D OMCTRY                 19     22A                                                      CSW207
     D OMCURR                 23     25A                                                      CSW207
     D OMNOST                 26     27A                                                      CSW207
     D OMACTI                 28     37A                                                      CSW207

      ** Initialize

     C                   EXSR      SRINIT

     C                   DO        *HIVAL

      ** Initialise & load subfile page

     C                   EXSR      SRIZSF
     C                   EVAL      W0RSF = 'N'

      ** Display screen until reload requested

     C                   DOW       W0RSF = 'N'

      ** Display screen

     C                   EXSR      SRDSPS

      ** Cancel & exit program

     C   03              CAS                     SREXIT

      ** Request subfile reload

     C***   05              CAS                     SRRQRL                                  BUG14042
     C   05              CAS                     SRREFR                                     BUG14042

      ** Exception report

     C   11              CAS                     SRREPT

      ** Display next SFL page

     C   27              CAS                     SRLDSF

      ** Process screen input

     C                   CAS                     SRPROC
     C                   END

     C                   ENDDO
     C                   ENDDO

      ** Terminate program

     C                   MOVE      '1'           *INLR
      *****************************************************************
      /EJECT
      *================================================================
      ** SRIZSF - Initialise and load subfile page
      *================================================================
     C     SRIZSF        BEGSR

      ** Clear subfile

     C                   EVAL      *IN80 = *ON
     C                   WRITE     RSFLCTL
     C                   EVAL      *IN80 = *OFF

      ** Reset no of records in subfile

     C                   Z-ADD     *ZERO         WRRN                 81
     C                   IF        WMODE <> 'ADD'
     C     *LIKE         DEFINE    SEOMNWRK      WZOMNWRK
     C                   EVAL      WZOMNWRK = *BLANKS
     C                   EVAL      WZOMNWRK = SEOMNWRK

      ** Position DBF file

     C     KPOS          KLIST
     C                   KFLD                    OMNWRK

      ** Setup key

     C                   EVAL      OMNWRK = SEOMNWRK
     C     KPOS          SETLL     MEOUFML1
     C                   READ      MEOUFML1                             8782
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
     C                   EXSR      SRLDSF

     C                   ENDSR
      /EJECT
      *================================================================
      ** SRLDSF - Load subfile page
      *================================================================
     C     SRLDSF        BEGSR

     C                   EVAL      *IN84 = *OFF

      ** Re-establish fields in read-ahead record

     C                   IF        *IN27 = *ON AND WMODE <> 'ADD'
     C  N82              READP     MEOUFML1                               90
     C  N82              READ      MEOUFML1                               90
     C                   ENDIF

      ** Start at previous highest record in SFL

     C                   EVAL      SRRN = WRRN
     C                   EVAL      WCTR = 0
     C                   EVAL      WCTR2 = 0

      ** Set required pages based on *Set Cursor or *Subfile Pages

     C                   IF        W0RR0 > 0
     C     W0RR0         DIV       WSFPG         WSPG
     C                   MVR                     WSLIN             3 0
     C                   IF        WSLIN > 0
     C                   EVAL      WSPG = WSPG + 1
     C                   ENDIF
     C                   IF        W0SPG > WSPG
     C                   EVAL      WSPG = W0SPG
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WSPG =  W0SPG
     C                   ENDIF

      ** Compute lines required based on pages

     C                   EVAL      WSFLN = (WSPG * WSFPG)
     C                   IF        WSFLN > 999
     C                   EVAL      WSFLN = 999
     C                   ENDIF

      ** Load next SFL page until SFL page full, or
      ** Scan limit reached

     C                   DOW       *IN82 = '0' AND WCTR < WSFLN AND
     C                             WCTR2 < W0SLM

      ** Setof record error indicators

     C                   MOVE      *ALL'0'       WKIND0            4
     C                   MOVEA     WKIND0        *IN(31)
     C                   EVAL      *IN36 = '0'
     C                   EVAL      *IN38 = '0'
     C                   EVAL      *IN20 = '0'
     C                   EVAL      *IN21 = '0'
     C                   EVAL      *IN40 = '0'
     C                   EVAL      *IN50 = '0'
     C                   EVAL      *IN51 = '0'

     C                   IF        PMMODE = 'E'
     C                   EVAL      *IN20 = '1'
     C                   EVAL      *IN40 = '1'
     C                   ELSE
     C                   IF        WMODE = 'CHG'
     C                   EVAL      *IN21 = '1'
     C                   ENDIF
     C                   ENDIF

      ** Filter field

     C                   EVAL      WINCLUDE = 'Y'
     C                   SELECT
     C                   WHEN      SEOMMTPY <> *BLANKS
     C                   IF        SEOMMTPY <> OMMTPY
     C                   EVAL      WINCLUDE = 'N'
     C                   ENDIF

     C                   WHEN      SEOMMTAG <> *BLANKS
     C                   IF        SEOMMTAG <> OMMTAG
     C                   EVAL      WINCLUDE = 'N'
     C                   ENDIF

     C                   WHEN      SEOMSBRC <> *BLANKS
     C                   IF        SEOMSBRC <> OMSBRC
     C                   EVAL      WINCLUDE = 'N'
     C                   ENDIF

     C                   WHEN      SEOMCTRY <> *BLANKS
     C                   IF        SEOMCTRY <> OMCTRY
     C                   EVAL      WINCLUDE = 'N'
     C                   ENDIF

     C                   WHEN      SEOMCURR <> *BLANKS
     C                   IF        SEOMCURR <> OMCURR
     C                   EVAL      WINCLUDE = 'N'
     C                   ENDIF

     C                   WHEN      SEOMNOST <> *BLANKS
     C                   IF        SEOMNOST <> OMNOST
     C                   EVAL      WINCLUDE = 'N'
     C                   ENDIF

     C                   WHEN      SEOMACTI <> *BLANKS
     C                   IF        SEOMACTI <> OMACTI
     C                   EVAL      WINCLUDE = 'N'
     C                   ENDIF

     C                   WHEN      SEOMFLAG <> *BLANKS
     C                   IF        SEOMFLAG <> OMFLAG
     C                   EVAL      WINCLUDE = 'N'
     C                   ENDIF

     C                   ENDSL

     C                   IF        WINCLUDE = 'Y'

     C                   EXSR      SRISFF

     C                   IF        WMODE <> 'ADD'

      ** Load SFL fields

     C                   EXSR      SRLSFF
     C                   EVAL      SDBRC = WDBRC
     C                   ENDIF

      ** Output to subfile

      ** if record is not duplicate                                                           CSW207
     C                   IF        WCOMP1 <> WCOMP2                                           CSW207
                                                                                              CSW207
     C                   EVAL      SRRN = SRRN + 1
     C                   ADD       1             WCTR                 81

     C                   WRITE     RSFLRCD

      ** Increment scan check count

     C                   EVAL      WCTR2 = WCTR2 + 1
     C                   ENDIF
                                                                                              CSW207
     C                   EVAL      WTNWRK =  OMNWRK                                           CSW207
     C                   EVAL      WTMTPY =  OMMTPY                                           CSW207
     C                   EVAL      WTMTAG =  OMMTAG                                           CSW207
     C                   EVAL      WTSBRC =  OMSBRC                                           CSW207
     C                   EVAL      WTCTRY =  OMCTRY                                           CSW207
     C                   EVAL      WTCURR =  OMCURR                                           CSW207
     C                   EVAL      WTNOST =  OMNOST                                           CSW207
     C                   EVAL      WTACTI =  OMACTI                                           CSW207
                                                                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        WMODE <> 'ADD'
     C                   READ      MEOUFML1                               82
     C                   ENDIF
     C                   ENDDO

      ** Save highest SFL record load can continue at end point

     C                   IF        SRRN > WRRN

      ** Calculate top line

     C     WCTR          DIV       WSFPG         WSPG
     C                   MVR                     WSLIN
     C                   IF        WSLIN > 0
     C                   EVAL      SSFRC = SRRN - WSLIN
     C                   ELSE
     C                   EVAL      SSFRC = SRRN - WSFPG
     C                   ENDIF
     C                   EVAL      SSFRC = SSFRC + 1
     C                   EVAL      WRRN = SRRN
     C                   ENDIF

      ** If scan limit reached, display error message

     C                   IF        WCTR2 >= W0SLM

      ** Send message 'Scan limit reached'

     C                   EVAL      ZAMSID = 'ME00010'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EVAL      WCTR = 0
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *================================================================
      ** SRDSPS - Display screen
      *================================================================
     C     SRDSPS        BEGSR

     C                   IF        *IN03 <> *ON
     C                   IF        *IN82 = '1' AND WRRN = 0

      ** Send message '*No data to display'

     C                   EVAL      ZAMSID = 'ME00001'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   IF        WF12 = 'Y'
     C                   EVAL      ZAMSID = 'MIN0001'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   IF        WFEnquir = 'Y'                                             CSW207
     C                             AND WF12 <> 'Y'                                            CSW207
     C                   EXSR      SRCLR                                                      CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        WFAmend = 'Y'                                              CSW207
     C                   EVAL      ZAMSID = 'ME00164'                                         CSW207
     C                   EVAL      ZAMSGF = 'MEMSG'                                           CSW207
     C                   EXSR      ZASNMS                                                     CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        WFDelete = 'Y'                                             CSW207
     C                   EVAL      ZAMSID = 'ME00033'                                         CSW207
     C                   EVAL      ZAMSGF = 'MEMSG'                                           CSW207
     C                   EXSR      ZASNMS                                                     CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   WRITE     RMSGCTL

     C                   EVAL      SCTX1 = WTXTC1
     C                   EVAL      SCTX2 = WTXTC2

     C                   WRITE     RCMDTXT1
     C                   WRITE     RCMDTXT2

      ** Update screen time

     C                   TIME                    STIME

     C                   EXFMT     RSFLCTL

     C                   EVAL      WFAmend = *Blanks                                          CSW207
     C                   EVAL      WFDelete= *Blanks                                          CSW207
     C                   EVAL      WFEnquir= *Blanks                                          CSW207
     C                   EVAL      WCOMP1 = *BLANKS                                           CSW207
                                                                                              CSW207
     C                   IF        SEOMMTPY <> *BLANKS OR
     C                             SEOMMTAG <> *BLANKS OR
     C                             SEOMNWRK <> *BLANKS OR                                   BUG14042
     C                             SEOMSBRC <> *BLANKS OR
     C                             SEOMCTRY <> *BLANKS OR
     C                             SEOMCURR <> *BLANKS OR
     C                             SEOMNOST <> *BLANKS OR
     C                             SEOMACTI <> *BLANKS OR
     C                             SEOMFLAG <> *BLANKS
     C                   EXSR      SRRQRL
     C                   ENDIF

      ** Maintain subfile position where possible

     C                   IF        @#SFRC > *ZERO
     C                   EVAL      SSFRC = @#SFRC
     C                   ENDIF

     C                   EVAL      WERROR   = 'N'                                           BUG14042
     C                   EVAL      WF12     = 'N'                                           BUG14042
     C                   EXSR      SRCLR

     C                   ENDIF
     C                   ENDSR
      /EJECT
      *================================================================
      ** SRPROC - Process screen input
      *================================================================
     C     SRPROC        BEGSR

     C                   IF        WMODE <> 'ADD' AND
     C                             *IN09 = *OFF   AND                                       BUG14042
     C                             WZOMNWRK <> SEOMNWRK
     C                   EXSR      SRRQRL
     C     W0RSF         CABEQ     'Y'           EXPROC
     C                   ENDIF

     C                   EVAL      WERR = *BLANK
     C                   EVAL      WNULL = 'Y'

     C                   IF        WRRN <> 0

     C                   IF        WMODE = 'CHG' OR PMMODE = 'E'
     C                   EXSR      SRPRS1
     C                   ENDIF

     C                   ENDIF

     C                   IF        WERR = *BLANK AND
     C                             *IN09 = '1'

     C                   EVAL      *IN30 = *OFF
     C                   EVAL      SACTCD = 'I'

     C                   EXSR      SRCLR
     C                   WRITE     RMSGCTL

     C                   EVAL      PMSGID = 'USR5203'
     C                   CALL      'SDRTVTXT'
     C     PMSGID        PARM      PMSGID        KE0286
     C     PMSGF         PARM      PMSGF         KE0287
     C     PMSGT         PARM      PMSGT         KE0288
     C                   MOVEL     PMSGT         SURPT

     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF

     C                   EVAL      SOMNWRK = *BLANKS
     C                   EVAL      SOMMTPY = *BLANKS
     C                   EVAL      SOMMTAG = *BLANKS
     C                   EVAL      SOMSBRC = *BLANKS
     C                   EVAL      SOMCTRY = *BLANKS
     C                   EVAL      SOMCURR = *BLANKS
     C                   EVAL      SOMNOST = *BLANKS
     C                   EVAL      SOMACTI = *BLANKS
     C                   EVAL      SOMFLAG = *BLANKS
     C                   EVAL      SOMDESC = *BLANKS

     C                   EVAL      WF12 = 'Y'

     C                   DOW       WF12 = 'Y' OR WERROR = 'Y'

     C                   EVAL      WF12 = 'N'
     C                   EVAL      WERROR = 'N'
     C                   EXFMT     RMNTRCD

     C                   IF        *IN03 = *ON
     C                   LEAVESR
     C                   ENDIF

     C                   IF        *IN12 = *ON
     C                   EVAL      WF12 = 'Y'
     C                   EXSR      SRCLR
     C                   EVAL      PMSGID = 'USR5201'
     C                   CALL      'SDRTVTXT'
     C     PMSGID        PARM      PMSGID        KE0286
     C     PMSGF         PARM      PMSGF         KE0287
     C     PMSGT         PARM      PMSGT         KE0288
     C                   MOVEL     PMSGT         SURPT
     C                   EXSR      SRRQRL
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      WERROR = 'N'
     C                   EXSR      SRCLR

      ** Validate maintenance screen1

     C                   EXSR      SRVREC
     C                   IF        WERROR = 'Y'
     C                   WRITE     RMSGCTL
     C                   ENDIF

     C                   IF        WERROR <> 'Y'
     C                   EXSR      SRCLR
     C                   EVAL      WERROR = 'Y'
     C                   DOW       WERROR = 'Y' AND WF12 <> 'Y'
     C                   WRITE     RMSGCTL
     C                   EXFMT     RMN2RCD

     C                   IF        *IN03 = *ON
     C                   LEAVESR
     C                   ENDIF

     C                   IF        *IN12 = *ON
     C                   EVAL      WF12 = 'Y'
     C                   ELSE
     C                   EVAL      WF12 = 'N'
     C                   ENDIF

      ** Validate maintenance screen2

     C                   EXSR      SRVREC2
     C                   IF        WERROR <> 'Y'
     C                   EXSR      SRCLR
     C                   ENDIF

     C                   ENDDO
     C                   ENDIF
                                                                                              CSW207
     C                   IF        WERROR <> 'Y'                                              CSW207
     C                             AND SOMACTI = '*FORMAT'                                    CSW207
     C                             AND CSW207  = 'Y'                                          CSW207
     C                   EXSR      SRCLR                                                      CSW207
     C                   EVAL      WERROR = 'Y'                                               CSW207
     C                   EVAL      UPDATEC = 'N'                                              CSW207
     C                   DOW       WERROR = 'Y' AND                                           CSW207
     C                             WF12 <> 'Y'                                                CSW207
     C                   WRITE     RMSGCTL                                                    CSW207
     C                   EVAL      RECCTR = 0                                                 CSW207
     C                   EXSR      PROCSF4                                                    CSW207
     C                   EXSR      SRCLR                                                      CSW207
                                                                                              CSW207
      * Set error indicators to OFF                                                           CSW207
     C                   MOVEA     '00000'       Arr5                                         CSW207
                                                                                              CSW207
     C                   IF        *IN03 = *ON                                                CSW207
     C                   LEAVESR                                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        *IN12 = *ON                                                CSW207
     C                   EVAL      WF12 = 'Y'                                                 CSW207
     C                   WRITE     RMSGCTL                                                    CSW207
     C                   EXSR      INZSF4                                                     CSW207
     C                   LEAVE                                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      WF12 = 'N'                                                 CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Validate maintenance screen4                                                         CSW207
                                                                                              CSW207
     C                   EVAL      UPDATEC = 'N'                                              CSW207
     C                   EVAL      WTERR   = 'N'                                              CSW207
     C                   EVAL      ERRSWC  = 0                                                CSW207
                                                                                              CSW207
     C                   READC     RSFLRC4                                                    CSW207
                                                                                              CSW207
      * Display error message - format is blanks                                              CSW207
     C                   IF        %EOF                                                       CSW207
     C                             AND SO50F = *Blanks                                        CSW207
     C                   EVAL      WERROR  = 'Y'                                              CSW207
     C                   EVAL      WTERR   = 'Y'                                              CSW207
     C                   EXSR      SRCLR                                                      CSW207
     C                   EVAL      ZAMSID = 'ME00163'                                         CSW207
     C                   EVAL      ZAMSGF = 'MEMSG'                                           CSW207
     C                   EXSR      ZASNMS                                                     CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   DOW       NOT %EOF                                                   CSW207
                                                                                              CSW207
      * Display error message - format is blanks                                              CSW207
     C                   IF        SO50F <> *Blanks                                           CSW207
     C                   EXSR      SRVREC4                                                    CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      WERROR  = 'Y'                                              CSW207
     C                   EVAL      WTERR   = 'Y'                                              CSW207
     C                   EXSR      SRCLR                                                      CSW207
     C                   EVAL      ZAMSID = 'ME00163'                                         CSW207
     C                   EVAL      ZAMSGF = 'MEMSG'                                           CSW207
     C                   EXSR      ZASNMS                                                     CSW207
     C                   LEAVE                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        *IN55 = *ON                                                CSW207
     C                   EVAL      UPDATEC = 'Y'                                              CSW207
     C                   EVAL      ERRSWC  = ERRSWC + 1                                       CSW207
     C                   IF        ERRSWC  = 1                                                CSW207
     C                   EVAL      SSRNB = SRRN                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EVAL      *IN85 = *ON                                                CSW207
     C                   UPDATE    RSFLRC4                                                    CSW207
     C                   MOVEA     '00000'       *IN(55)                                      CSW207
     C                   READC     RSFLRC4                                                    CSW207
     C                   ENDDO                                                                CSW207
                                                                                              CSW207
     C                   IF        WTERR  = 'N'                                               CSW207
                                                                                              CSW207
     C     0             CHAIN     RSFLRC4                                                    CSW207
                                                                                              CSW207
     C                   READC     RSFLRC4                                                    CSW207
     C                   DOW       NOT %EOF                                                   CSW207
                                                                                              CSW207
     C                   EVAL      WERROR = 'N'                                               CSW207
                                                                                              CSW207
     C     KMEOU0        CHAIN     MEOUFML7                                                   CSW207
     C                   IF        *IN55 <> *ON                                               CSW207
     C                             AND NOT %FOUND(MEOUFML7)                                   CSW207
     C                             AND SO50F <> *BLANKS                                       CSW207
     C                   EXSR      SRADD                                                      CSW207
     C                   EVAL      UPDATEC = 'N'                                              CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      UPDATEC = 'Y'                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   UPDATE    RSFLRC4                                                    CSW207
     C                   MOVEA     '00000'       *IN(55)                                      CSW207
     C                   EVAL      *IN85 = *OFF                                               CSW207
                                                                                              CSW207
     C                   READC     RSFLRC4                                                    CSW207
     C                   ENDDO                                                                CSW207
                                                                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDDO                                                                CSW207
     C                   ENDIF                                                                CSW207

     C                   ENDDO

     C                   IF        SOMACTI <> '*FORMAT'                                       CSW207
     C                             OR CSW207 <> 'Y'                                           CSW207
     C                   EXSR      SRADD
     C                   ENDIF                                                                CSW207

     C                   EXSR      SRRQRL

     C                   EVAL      PMSGID = 'USR5201'
     C                   CALL      'SDRTVTXT'
     C     PMSGID        PARM      PMSGID        KE0286
     C     PMSGF         PARM      PMSGF         KE0287
     C     PMSGT         PARM      PMSGT         KE0288
     C                   MOVEL     PMSGT         SURPT

     C                   EVAL      WF12 = 'N'

     C                   ENDIF

     C     EXPROC        ENDSR
      /EJECT
      *================================================================
      ** SRPRS1 - Validate input
      *================================================================
     C     SRPRS1        BEGSR

     C                   READC     RSFLRCD                                92

      ** Check if Subfile needs Reload                                                      BUG14042
     C                   IF        *IN92 = *ON  And                                         BUG14042
     C                             SEOMNWRK = *BLANKS  And                                  BUG14042
     C                             SEOMMTAG = *BLANKS  And                                  BUG14042
     C                             SEOMSBRC = *BLANKS  And                                  BUG14042
     C                             SEOMCTRY = *BLANKS  And                                  BUG14042
     C                             SEOMCURR = *BLANKS  And                                  BUG14042
     C                             SEOMNOST = *BLANKS  And                                  BUG14042
     C                             SEOMACTI = *BLANKS  And                                  BUG14042
     C                             SEOMFLAG = *BLANKS                                       BUG14042
     C                   EVAL      WERROR   = 'N'                                           BUG14042
     C                   EVAL      WF12     = 'N'                                           BUG14042
     C                   EXSR      SRRQRL                                                   BUG14042
     C                   LEAVESR                                                            BUG14042
     C                   ENDIF                                                              BUG14042
                                                                                            BUG14042
      ** Process subfile record

     C                   DOW       *IN92 = '0'

      ** Setof record error indicators

     C                   MOVEL     *ALL'0'       WKIND0
     C                   MOVEA     WKIND0        *IN(31)
     C                   EVAL      *IN36 = '0'
     C                   EVAL      *IN38 = '0'
     C                   EVAL      WNULL = 'N'
     C                   EVAL      *IN84  = '1'
     C                   IF        PMMODE = 'M' AND SCSEL <> 'D' AND
     C                                              SCSEL <> 'A' AND
     C                                              SCSEL <> 'E' AND
     C                                              SCSEL <> *BLANK OR
     C                             PMMODE = 'E' AND SCSEL <> 'E' AND
     C                                              SCSEL <> *BLANK
     C                   EVAL      *IN34 = '1'
     C                   IF        WERR = *BLANK
     C                   EVAL      WERR = 'Y'
     C                   EVAL      SSFRC = SRRN
     C                   EVAL      ZAMSID = 'ME00002'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF

     C                   IF        WERR <> 'Y' AND SCSEL = 'A' OR
     C                             WERR <> 'Y' AND SCSEL = 'E' OR
     C                             WERR <> 'Y' AND SCSEL = 'D'
     C                   EVAL      SACTCD = SCSEL
     C     KMEOU         CHAIN     MEOUFML1
     C                   IF        %FOUND(MEOUFML1)
     C                   EVAL      SOMNWRK = OMNWRK
     C                   EVAL      SOMMTPY = OMMTPY
     C                   EVAL      SOMMTAG = OMMTAG
     C                   EVAL      SOMSBRC = OMSBRC
     C                   EVAL      SOMCTRY = OMCTRY
     C                   EVAL      SOMCURR = OMCURR
     C                   EVAL      SOMNOST = OMNOST
     C                   EVAL      SOMACTI = OMACTI

     C                   EVAL      SOMFLAG = OMFLAG
     C                   EVAL      SOMDESC = OMDESC
     C                   EVAL      SOMAUSR = OMAUSR
     C                   EVAL      SOMARDT = OMARDT
     C                   EVAL      SOMATIM = OMATIM
     C                   EXSR      SRVREC3                                                  BUG14042

     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN44 = *OFF                                             BUG14042
     C                   IF        SCSEL = 'E' OR SCSEL = 'D'
     C                   EVAL      *IN30 = *ON
     C                   EVAL      *IN34 = *ON
     C                   ENDIF

     C                   SELECT
     C                   WHEN      SCSEL = 'A'
     C                   EVAL      PMSGID = 'USR5204'
     C                   WHEN      SCSEL = 'D'
     C                   EVAL      PMSGID = 'USR5205'
     C                   EVAL      *IN44 = *ON                                              BUG14042
     C                   WHEN      SCSEL = 'E'
     C                   EVAL      PMSGID = 'USR5206'
     C                   ENDSL

     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        KE0286
     C     PMSGF         PARM      PMSGF         KE0287
     C     PMSGT         PARM      PMSGT         KE0288
     C                   MOVEL     PMSGT         SURPT

     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF

     C                   EVAL      WF12 = 'Y'
     C                   EVAL      UPDATEC = 'N'                                              CSW207

     C                   DOW       WF12 = 'Y' OR WERROR = 'Y'

     C                   EVAL      WF12 = 'N'
     C                   EVAL      WERROR = 'N'
     C**********         EXFMT     RMNTRCD                                                  BUG14042
     C                   WRITE     RMSGCTL                                                  BUG14042
                                                                                              CSW207
     C                   EVAL      *IN12 = *OFF                                               CSW207
     C                   IF        SOMACTI = '*FORMAT'                                        CSW207
     C                             AND CSW207 = 'Y'                                           CSW207
                                                                                              CSW207
     C                   IF        SCSEL = 'E'                                                CSW207
     C                             OR SCSEL = 'D'                                             CSW207
     C                   EVAL      WFEnquir = 'Y'                                             CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EVAL      WERROR = 'Y'                                               CSW207
     C                   DOW       WERROR = 'Y' AND                                           CSW207
     C                             WF12 <> 'Y'                                                CSW207
     C                   WRITE     RMSGCTL                                                    CSW207
     C                   EVAL      WERROR = 'N'                                               CSW207
     C                   EVAL      RECCTR = 0                                                 CSW207
     C                   EXSR      PROCSF4                                                    CSW207
     C                   EXSR      SRCLR                                                      CSW207
                                                                                              CSW207
      * Set error indicators to OFF                                                           CSW207
     C                   MOVEA     '00000'       Arr5                                         CSW207
                                                                                              CSW207
      * Validate OM Flag                                                                      CSW207
     C                   EXSR      SRVREC2                                                    CSW207
     C                   IF        WERROR = 'Y'                                               CSW207
     C                   LEAVESR                                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        *IN03 = *ON                                                CSW207
     C                   LEAVESR                                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        *IN12 = *ON                                                CSW207
     C                   EVAL      WF12 = 'Y'                                                 CSW207
     C                   LEAVE                                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      WF12 = 'N'                                                 CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EVAL      UPDATEC = 'N'                                              CSW207
     C                   EVAL      WTERR   = 'N'                                              CSW207
     C                   EVAL      ERRSWC  = 0                                                CSW207
     C                   READC     RSFLRC4                                                    CSW207
     C                   DOW       NOT %EOF                                                   CSW207
     C                   EXSR      SRVREC4                                                    CSW207
                                                                                              CSW207
     C                   IF        *IN55 = *ON                                                CSW207
     C                   EVAL      UPDATEC = 'Y'                                              CSW207
     C                   EVAL      ERRSWC  = ERRSWC + 1                                       CSW207
     C                   IF        ERRSWC  = 1                                                CSW207
     C                   EVAL      SSRNB = SRRN                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EVAL      *IN85 = *ON                                                CSW207
     C                   UPDATE    RSFLRC4                                                    CSW207
     C                   MOVEA     '00000'       *IN(55)                                      CSW207
     C                   READC     RSFLRC4                                                    CSW207
     C                   ENDDO                                                                CSW207
                                                                                              CSW207
     C                   IF        WTERR  = 'N'                                               CSW207
                                                                                              CSW207
     C     0             CHAIN     RSFLRC4                                                    CSW207
     C                   READC     RSFLRC4                                                    CSW207
     C                   DOW       NOT %EOF                                                   CSW207
                                                                                              CSW207
      * Delete formats under Amend records                                                    CSW207
     C                   IF        SCSEL = 'A'                                                CSW207
     C                             AND SOM50FS <> *BLANKS                                     CSW207
     C                             AND SO50F = *BLANKS                                        CSW207
     C     KMEOU0        CHAIN     MEOUFML7                                                   CSW207
     C                   IF        %FOUND(MEOUFML7)                                           CSW207
     C                   EVAL      WFAmend = 'Y'                                              CSW207
     C                   EVAL      UPDATEC = 'N'                                              CSW207
     C                   DELETE    @OUFMPDX7                                                  CSW207
     C                   ENDIF                                                                CSW207
     C                   ELSE                                                                 CSW207
                                                                                              CSW207
     C                   IF        *IN55 <> *ON                                               CSW207
     C                   EVAL      WFAmend = 'Y'                                              CSW207
     C                   EXSR      SRAMD                                                      CSW207
     C                   EVAL      WF12 = 'N'                                                 CSW207
     C                   EVAL      UPDATEC = 'N'                                              CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      UPDATEC = 'Y'                                              CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   UPDATE    RSFLRC4                                                    CSW207
     C                   MOVEA     '00000'       *IN(55)                                      CSW207
     C                   EVAL      *IN85 = *OFF                                               CSW207
                                                                                              CSW207
     C                   READC     RSFLRC4                                                    CSW207
     C                   ENDDO                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDDO                                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EXFMT     RMN2RCD                                                  BUG14042
     C                   ENDIF                                                                CSW207
                                                                                              CSW207

     C                   IF        *IN03 = *ON
     C                   LEAVESR
     C                   ENDIF

     C                   IF        *IN12 = *ON
     C                   EVAL      WF12 = 'Y'
     C                   EXSR      SRCLR
     C                   IF        PMMODE = 'M' AND SCSEL = 'E' OR
     C                             PMMODE = 'M' AND SCSEL = 'D' OR
     C                             PMMODE = 'M' AND SCSEL = 'A'
     C                   EVAL      PMSGID = 'USR5201'
     C                   CALL      'SDRTVTXT'
     C     PMSGID        PARM      PMSGID        KE0286
     C     PMSGF         PARM      PMSGF         KE0287
     C     PMSGT         PARM      PMSGT         KE0288
     C                   MOVEL     PMSGT         SURPT
     C                   ENDIF
     C                   EXSR      SRRQRL
     C                   LEAVESR
     C                   ENDIF

      ** Validate maintenance screen1

     C                   IF        SCSEL = 'A'
     C                   EVAL      WERROR = 'N'
     C                   EXSR      SRCLR
     C**********         EXSR      SRVREC                                                   BUG14042
     C                   IF        WERROR = 'Y'
     C                   WRITE     RMSGCTL
     C                   ELSE                                                               BUG14042
     C                   EXSR      SRVREC2                                                  BUG14042
     C                   ENDIF
     C                   ENDIF

     C**********         IF        WERROR <> 'Y'                                            BUG14042
     C**********         EXSR      SRCLR                                                    BUG14042
     C**********         EVAL      WERROR = 'Y'                                             BUG14042
     C**********         DOW       WERROR = 'Y' AND WF12 <> 'Y'                             BUG14042
     C**********         WRITE     RMSGCTL                                                  BUG14042
     C**********         EXFMT     RMN2RCD                                                  BUG14042

     C**********         IF        *IN03 = *ON                                              BUG14042
     C**********         LEAVESR                                                            BUG14042
     C**********         ENDIF                                                              BUG14042

     C**********         IF        *IN12 = *ON                                              BUG14042
     C**********         EVAL      WF12 = 'Y'                                               BUG14042
     C**********         ELSE                                                               BUG14042
     C**********         EVAL      WF12 = 'N'                                               BUG14042
     C**********         EVAL      WERROR = 'N'                                             BUG14042
     C**********         ENDIF                                                              BUG14042
      **********                                                                            BUG14042
      ***Validate*maintenance*screen2                                                       BUG14042
      **********                                                                            BUG14042
     C**********         IF        SCSEL = 'A'                                              BUG14042
     C**********         EXSR      SRVREC2                                                  BUG14042
     C**********         ENDIF                                                              BUG14042
     C**********         ENDDO                                                              BUG14042
     C**********         ENDIF                                                              BUG14042

     C                   ENDDO
     C                   IF        WFAmend = *Blanks                                          CSW207
     C                   EXSR      SRAMD
     C                   ENDIF                                                                CSW207
     C                   EVAL      WF12 = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        SCSEL = 'D'
     C                             And *IN10 = *ON                                          BUG14042
     C                   EXSR      SRDEL
     C                   ENDIF

     C                   UPDATE    RSFLRCD
     C                   READC     RSFLRCD                                92

     C                   EXSR      SRRQRL

     C                   ENDDO

     C                   IF        PMMODE = 'M' AND SCSEL = 'E' OR
     C                             PMMODE = 'M' AND SCSEL = 'D'
     C                             OR PMMODE = 'M' AND SCSEL = 'A'                            CSW207
     C                   EVAL      PMSGID = 'USR5201'
     C                   CALL      'SDRTVTXT'
     C     PMSGID        PARM      PMSGID        KE0286
     C     PMSGF         PARM      PMSGF         KE0287
     C     PMSGT         PARM      PMSGT         KE0288
     C                   MOVEL     PMSGT         SURPT
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *================================================================
      ** SRVREC - Validate details screen1 fields
      *================================================================
     C     SRVREC        BEGSR

     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF

     C                   EVAL      WERROR = 'N'

     C                   CALL      'AONWRKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      SOMNWRK       PNWRK             6
     C                   PARM      *BLANKS       DSFDY

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      DSNWRK = DSFDY
     C                   EVAL      SDOMNWRK = EDNETD
     C                   EVAL      SOMNWRK  = PNWRK                                         BUG14042
     C                   ELSE
     C                   EVAL      ZAMSID = 'ME00103'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   LEAVESR
     C                   END

     C                   CALL      'AOMTPYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      SOMMTPY       PMTPY             3
     C     SDMTPY        PARM      SDMTPY        DSFDY
     C                   IF        PRTCD  = *BLANKS                                         BUG14042
     C                   EVAL      SOMMTPY  = PMTPY                                         BUG14042
     C                   ENDIF                                                              BUG14042
      *                                                                                     BUG14042
      ** Check valid combination for SWIFT, TELEX, PAPER                                    BUG14042
      *                                                                                     BUG14042
     C                   EVAL      *IN44 = *OFF                                             BUG14042
     C                   IF        SOMNWRK = 'SWIFT'   Or                                   BUG14042
     C                             SOMNWRK = 'TELEX'                                        BUG14042
     C                   MOVEL     SOMMTPY       WVAL2                                      BUG14042
     C     WVAL2         SCAN      WVAL1                                                    BUG14042
     C                   IF        %FOUND = *OFF                                            BUG14042
     C                   EVAL      *IN44 = *ON                                              BUG14042
     C                   EVAL      PRTCD = '*NRF'                                           BUG14042
     C                   ENDIF                                                              BUG14042
     C                   ENDIF                                                              BUG14042
     C                   IF        SOMNWRK = 'PAPER'   And                                  BUG14042
     C                             SOMMTPY <>'ADV'                                          BUG14042
     C                   EVAL      *IN44 = *ON                                              BUG14042
     C                   EVAL      PRTCD = '*NRF'                                           BUG14042
     C                   ENDIF                                                              BUG14042

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      SDOMMTPY = EEMTPD
     C                   ELSE
     C                   IF        *IN44 = *ON                                              BUG14042
     C                   SELECT                                                             BUG14042
     C                   WHEN      SOMNWRK = 'SWIFT'                                        BUG14042
     C                   EVAL      ZAMSID = 'ME00105'                                       BUG14042
     C                   WHEN      SOMNWRK = 'TELEX'                                        BUG14042
     C                   EVAL      ZAMSID = 'ME00106'                                       BUG14042
     C                   WHEN      SOMNWRK = 'PAPER'                                        BUG14042
     C                   EVAL      ZAMSID = 'ME00107'                                       BUG14042
     C                   ENDSL                                                              BUG14042
     C                   ELSE                                                               BUG14042
     C                   EVAL      ZAMSID = 'ME00104'
     C                   ENDIF                                                              BUG14042
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   LEAVESR
     C                   ENDIF

     C                   CALL      'AOMTAGR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      SOMMTAG       PMTAG             5
     C                   PARM      SOMMTPY       PMTPY             3
     C                   PARM      *BLANKS       DSFDY

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      DSMTAG = DSFDY
     C                   EVAL      SDOMMTAG = EFSCFD
     C                   EVAL      SOMMTAG  = PMTAG                                         BUG14042
     C                   ELSE
     C                   EVAL      ZAMSID = 'ME00108'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   LEAVESR
     C                   END

     C                   IF        SOMSBRC <> *BLANKS And                                   BUG14042
     C                             SOMSBRC <> '*FTF'  And                                   BUG14042
     C                             SOMSBRC <> '*NFT'                                        BUG14042
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      SOMSBRC       PBRCA             3
     C     SDBRCH        PARM      SDBRCH        DSLDY
     C                   ENDIF                                                              BUG14042

     C                   MOVEL     SOMSBRC       WVAL2                                      BUG14042
     C                   IF        PRTCD = *BLANKS
     C                   IF        SOMSBRC  = *BLANKS  OR                                   BUG14042
     C                             WVAL2 = '*'                                              BUG14042
     C                   EVAL      SDOMSBRC = *BLANKS                                       BUG14042
     C                   ELSE                                                               BUG14042
     C**********         EVAL      SDOMSBRC = A8BRCD                                        BUG14042
     C                   EVAL      SDOMSBRC = A8BRNM                                        BUG14042
     C                   EVAL      SOMSBRC  = PBRCA                                         BUG14042
     C                   ENDIF                                                              BUG14042
     C                   ELSE
     C                   IF        WVAL2 = '*'                                              BUG14042
     C                   EVAL      ZAMSID = 'ME00110'                                       BUG14042
     C                   ELSE                                                               BUG14042
     C                   EVAL      ZAMSID = 'ME00109'
     C                   ENDIF                                                              BUG14042
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN36 = *ON
     C                   LEAVESR
     C                   ENDIF

     C                   IF        SOMCTRY <> *BLANKS And                                   BUG14042
     C                             SOMCTRY <> '*FTF'  And                                   BUG14042
     C                             SOMCTRY <> '*NFT'                                        BUG14042
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      SOMCTRY       WOMCTRY
     C     SDCTRY        PARM      SDCTRY        DSSDY
     C                   ENDIF                                                              BUG14042

     C                   MOVEL     SOMCTRY       WVAL2                                      BUG14042
     C                   IF        PRTCD = *BLANKS
     C                   IF        SOMCTRY  = *BLANKS  OR                                   BUG14042
     C                             WVAL2 = '*'                                              BUG14042
     C                   EVAL      SDOMCTRY = *BLANKS                                       BUG14042
     C                   ELSE                                                               BUG14042
     C                   EVAL      SDOMCTRY = A4CNNM
     C                   EVAL      SOMCTRY  = WOMCTRY                                       BUG14042
     C                   ENDIF                                                              BUG14042
     C                   ELSE
     C                   IF        WVAL2 = '*'                                              BUG14042
     C                   EVAL      ZAMSID = 'ME00112'
     C                   ELSE                                                               BUG14042
     C                   EVAL      ZAMSID = 'ME00111'                                       BUG14042
     C                   ENDIF                                                              BUG14042
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN38 = *ON
     C                   LEAVESR
     C                   ENDIF

     C**********         IF        SOMNOST <> *BLANKS OR SOMCURR <> *BLANKS                 BUG14042
     C                   IF        SOMCURR <> *BLANKS                                         250600
                                                                                            BUG17503
     C                   IF        SOMMTPY = '101' AND                                      BUG17503
     C                             SOMNWRK = 'SWIFT'                                        BUG17503
     C                   EVAL      ZAMSID = 'ME00166'                                       BUG17503
     C                   EVAL      ZAMSGF = 'MEMSG'                                         BUG17503
     C                   EXSR      ZASNMS                                                   BUG17503
     C                   EVAL      WERROR = 'Y'                                             BUG17503
     C                   EVAL      *IN39 = *ON                                              BUG17503
     C                   ELSE                                                               BUG17503
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      SOMCURR       WSOMCURR
     C     SDCURR        PARM      *BLANKS       DSSDY

     C                   IF        PRTCD = *BLANKS
     C**********                   Or SOMCURR = *BLANKS                              BUG14042 250600
     C                   EVAL      SDOMCURR = A6CYNM
     C                   EVAL      SOMCURR  = WSOMCURR                                      BUG14042
     C                   IF        SOMCURR  = *BLANKS                                       BUG14042
     C                   EVAL      SDOMCURR = *BLANKS                                       BUG14042
     C                   ENDIF                                                              BUG14042
     C                   ELSE
     C                   EVAL      ZAMSID = 'ME00113'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN39 = *ON
     C                   LEAVESR
     C                   ENDIF
     C**********         ENDIF                                                              BUG14042
     C                   ENDIF                                                              BUG17503
     C                   ENDIF                                                                250600
                                                                                            BUG17503
     C                   IF        SOMNOST <> *BLANKS AND                                   BUG17503
     C                             SOMMTPY = '101' AND                                      BUG17503
     C                             SOMNWRK = 'SWIFT'                                        BUG17503
     C                   EVAL      ZAMSID = 'ME00166'                                       BUG17503
     C                   EVAL      ZAMSGF = 'MEMSG'                                         BUG17503
     C                   EXSR      ZASNMS                                                   BUG17503
     C                   EVAL      WERROR = 'Y'                                             BUG17503
     C                   EVAL      *IN41 = *ON                                              BUG17503
     C                   ELSE                                                               BUG17503

     C                   IF        SOMNOST <> *BLANKS AND SOMCURR =  *BLANKS                  250600
     C                   EVAL      ZAMSID = 'ME00149'                                         250600
     C                   EVAL      ZAMSGF = 'MEMSG'                                           250600
     C                   EXSR      ZASNMS                                                     250600
     C                   EVAL      WERROR = 'Y'                                               250600
     C                   EVAL      *IN39 = *ON                                                250600
     C                   EVAL      *IN41 = *ON                                                250600
     C                   ELSE                                                                 250600
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM      SOMCURR       @CYCD             3
     C                   PARM      *BLANKS       @ACCD            10
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM      SOMNOST       @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      *BLANKS       DSFDY

     C                   IF        PRTCD = *BLANKS
     C                             Or SOMNOST = *BLANKS                                     BUG14042
     C                   IF        @NONB = *BLANKS                                          BUG14042
     C                   EVAL      SDOMNOST = *BLANKS                                       BUG14042
     C                   ELSE                                                               BUG14042
     C                   EVAL      SDOMNOST = A7NOSN
     C                   ENDIF                                                              BUG14042
     C                   EVAL      SOMNOST  = @NONB                                         BUG14042
     C                   ELSE
     C                   EVAL      ZAMSID = 'ME00114'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN39 = *ON                                              BUG14042
     C                   EVAL      *IN41 = *ON
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF                                                                250600
     C                   ENDIF                                                              BUG17503

      ** Action

     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   Z-ADD     1104003       Y2LSNO                                       CSW215
     C                   ELSE                                                                 CSW215
     C                   Z-ADD     1104001       Y2LSNO                                       CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW215
     C                   EVAL      SELECTION = *BLANKS                                      BUG14042
     C                   EVAL      WQRYFLD = SOMACTI
     C                   IF        WQRYFLD = '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    PRTCD
     C**********         PARM      1104001       Y2LSNO            7 0                        CSW215
     C                   PARM                    Y2LSNO            7 0                        CSW215
     C     SOMACTI       PARM                    SELECTION        20
     C                   ENDIF

     C                   IF        CSW207 <> 'Y'                                            BUG15140
     C                             AND SOMACTI =  '*FORMAT'                                 BUG15140
     C                   EVAL      ZAMSID = 'MEM0010'                                       BUG15140
     C                   EVAL      ZAMSGF = 'MEMSG'                                         BUG15140
     C                   EXSR      ZASNMS                                                   BUG15140
     C                   EVAL      WERROR = 'Y'                                             BUG15140
     C                   EVAL      *IN42 = *ON                                              BUG15140
     C                   LEAVESR                                                            BUG15140
     C                   ENDIF                                                              BUG15140
                                                                                            BUG15140

     C                   IF        SOMACTI <> 'ACOUNTLINE' AND
     C                             SOMACTI <> 'ACOUNTIBAN'
     C                             AND SOMACTI <> '*FORMAT'                                   CSW207
     C                   EVAL      ZAMSID = 'ME00115'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN42 = *ON
     C                   LEAVESR
     C                   ENDIF
      *                                                                                       CSW208
      ** Action *FORMAT only allowed for tags 50F                                             CSW208
      ** and 59F if CSW215 is installed                                                       CSW215
      *                                                                                       CSW208
     C                   IF        CSW208 = 'Y'                                               CSW208
     C                             AND SOMACTI = '*FORMAT'                                    CSW208
     C                             AND SOMMTAG <> ':50F:'                                     CSW208
     C                             AND SOMMTAG <> ':59F:'                                     CSW215
     C                             OR SOMMTAG = ':59F:'                                       CSW215
     C                             AND CSW215 = 'N'                                           CSW215
     C                             AND SOMACTI = '*FORMAT'                                  MD034562
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   EVAL      ZAMSID = 'ME00334'                                         CSW215
     C                   EVAL      ZAMSGF = 'MEMSG'                                           CSW215
     C                   EXSR      ZASNMS                                                     CSW215
     C                   EVAL      WERROR = 'Y'                                               CSW215
     C                   EVAL      *IN42 = *ON                                                CSW215
     C                   LEAVESR                                                              CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      ZAMSID = 'ME00167'                                         CSW208
     C                   EVAL      ZAMSGF = 'MEMSG'                                           CSW208
     C                   EXSR      ZASNMS                                                     CSW208
     C                   EVAL      WERROR = 'Y'                                               CSW208
     C                   EVAL      *IN42 = *ON                                                CSW208
     C                   LEAVESR                                                              CSW208
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW208

     C     KMEOU         CHAIN     MEOUFML0                                                   CSW207
     C                   IF        %FOUND(MEOUFML0)                                           CSW207
     C                   EVAL      ZAMSID = 'ME00007'                                         CSW207
     C                   EVAL      ZAMSGF = 'MEMSG'                                           CSW207
     C                   EXSR      ZASNMS                                                     CSW207
     C                   EVAL      WERROR = 'Y'                                               CSW207
     C                   EVAL      *IN31 = *ON                                                CSW207
     C                   EVAL      *IN32 = *ON                                                CSW207
     C                   EVAL      *IN33 = *ON                                                CSW207
     C                   EVAL      *IN36 = *ON                                                CSW207
     C                   EVAL      *IN38 = *ON                                                CSW207
     C                   EVAL      *IN39 = *ON                                                CSW207
     C                   EVAL      *IN41 = *ON                                                CSW207
     C                   EVAL      *IN42 = *ON                                                CSW207
     C                   LEAVESR                                                              CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C     EXVREC        ENDSR
      /EJECT
      *================================================================
      ** SRVREC2 - Validate details screen2 fields
      *================================================================
     C     SRVREC2       BEGSR

     C                   EVAL      WERROR = 'N'

     C                   IF        SOMFLAG = '?'
     C                   CALL      'Y2VLLSR'
     C                   PARM                    PRTCD
     C                   PARM      1104002       Y2LSNO            7 0
     C     SOMFLAG       PARM                    SELECTION        20
     C                   ENDIF

     C                   IF        SOMFLAG <> 'M' AND
     C                             SOMFLAG <> 'O' AND
     C                             SOMFLAG <> 'P' AND
     C                             SOMFLAG <> 'W'
     C                   EVAL      ZAMSID = 'ME00116'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EVAL      *IN43 = *ON
     C                   LEAVESR
     C                   IF        SOMFLAG = 'P' AND SOMACTI = 'ACOUNTIBAN'
     C                   EVAL      ZAMSID = 'ME00117'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF

     C     EXVREC2       ENDSR
      /EJECT
      *================================================================                     BUG13798
      ** SRVREC3 - Capture Description for Amend, Enquire, Delete Screen                    BUG13798
      *================================================================                     BUG13798
     C     SRVREC3       BEGSR                                                              BUG13798
                                                                                            BUG13798
     C                   EVAL      SDOMNWRK = *BLANKS                                       BUG13798
     C                   CALL      'AONWRKR0'                                               BUG13798
     C                   PARM      *BLANKS       PRTCD                                      BUG13798
     C                   PARM      '*KEY   '     POPTN                                      BUG13798
     C                   PARM      SOMNWRK       PNWRK                                      BUG13798
     C                   PARM      *BLANKS       DSFDY                                      BUG13798
     C                   IF        PRTCD = *BLANKS                                          BUG13798
     C                   EVAL      DSNWRK = DSFDY                                           BUG13798
     C                   EVAL      SDOMNWRK = EDNETD                                        BUG13798
     C                   ENDIF                                                              BUG13798
                                                                                            BUG13798
     C                   EVAL      SDOMMTPY = *BLANKS                                       BUG13798
     C                   CALL      'AOMTPYR0'                                               BUG13798
     C                   PARM      *BLANKS       PRTCD                                      BUG13798
     C                   PARM      '*KEY    '    POPTN                                      BUG13798
     C                   PARM      SOMMTPY       PMTPY             3                        BUG13798
     C     SDMTPY        PARM      SDMTPY        DSFDY                                      BUG13798
     C                   IF        PRTCD = *BLANKS                                          BUG13798
     C                   EVAL      SDOMMTPY = EEMTPD                                        BUG13798
     C                   ENDIF                                                              BUG13798
                                                                                            BUG13798
     C                   EVAL      SDOMMTAG = *BLANKS                                       BUG13798
     C                   CALL      'AOMTAGR0'                                               BUG13798
     C                   PARM      *BLANKS       PRTCD                                      BUG13798
     C                   PARM      '*KEY   '     POPTN                                      BUG13798
     C                   PARM      SOMMTAG       PMTAG             5                        BUG13798
     C                   PARM      SOMMTPY       PMTPY             3                        BUG13798
     C                   PARM      *BLANKS       DSFDY                                      BUG13798
     C                   IF        PRTCD = *BLANKS                                          BUG13798
     C                   EVAL      DSMTAG = DSFDY                                           BUG13798
     C                   EVAL      SDOMMTAG = EFSCFD                                        BUG13798
     C                   ENDIF                                                              BUG13798
                                                                                            BUG13798
     C                   EVAL      SDOMSBRC = *BLANKS                                       BUG13798
     C                   CALL      'AOBRCHR0'                                               BUG13798
     C                   PARM      *BLANKS       PRTCD                                      BUG13798
     C                   PARM      '*KEY   '     POPTN                                      BUG13798
     C                   PARM      SOMSBRC       PBRCA             3                        BUG13798
     C     SDBRCH        PARM      SDBRCH        DSLDY                                      BUG13798
     C                   IF        PRTCD = *BLANKS                                          BUG13798
     C                   EVAL      SDOMSBRC = A8BRNM                                        BUG13798
     C                   ENDIF                                                              BUG13798
                                                                                            BUG13798
     C                   EVAL      SDOMCTRY = *BLANKS                                       BUG13798
     C                   CALL      'AOCTRYR0'                                               BUG13798
     C                   PARM      *BLANKS       PRTCD                                      BUG13798
     C                   PARM      '*KEY   '     POPTN                                      BUG13798
     C                   PARM      SOMCTRY       WOMCTRY                                    BUG13798
     C     SDCTRY        PARM      SDCTRY        DSSDY                                      BUG13798
     C                   IF        PRTCD = *BLANKS                                          BUG13798
     C                   EVAL      SDOMCTRY = A4CNNM                                        BUG13798
     C                   ENDIF                                                              BUG13798
                                                                                            BUG13798
     C                   EVAL      SDOMCURR = *BLANKS                                       BUG13798
     C                   CALL      'AOCURRR0'                                               BUG13798
     C                   PARM      *BLANKS       PRTCD                                      BUG13798
     C                   PARM      '*KEY   '     POPTN                                      BUG13798
     C                   PARM      SOMCURR       WSOMCURR                                   BUG13798
     C     SDCURR        PARM      *BLANKS       DSSDY                                      BUG13798
     C                   IF        PRTCD = *BLANKS                                          BUG13798
     C                   EVAL      SDOMCURR = A6CYNM                                        BUG13798
     C                   ENDIF                                                              BUG13798
                                                                                            BUG13798
     C                   EVAL      SDOMNOST = *BLANKS                                       BUG13798
     C                   CALL      'AONOSTR0'                                               BUG13798
     C                   PARM      *BLANKS       PRTCD                                      BUG13798
     C                   PARM      '*KEY   '     POPTN                                      BUG13798
     C                   PARM      *BLANKS       @CUST             6                        BUG13798
     C                   PARM      SOMCURR       @CYCD             3                        BUG13798
     C                   PARM      *BLANKS       @ACCD            10                        BUG13798
     C                   PARM      *BLANKS       @ACSN             2                        BUG13798
     C                   PARM      SOMNOST       @NONB             2                        BUG13798
     C                   PARM      *BLANKS       @BRCD             3                        BUG13798
     C                   PARM      *BLANKS       @CSSN            10                        BUG13798
     C                   PARM      *BLANKS       @PNOI             1                        BUG13798
     C     SDNOST        PARM      *BLANKS       DSFDY                                      BUG13798
     C                   IF        PRTCD = *BLANKS                                          BUG13798
     C                   EVAL      SDOMNOST = A7NOSN                                        BUG13798
     C                   ENDIF                                                              BUG13798
                                                                                            BUG13798
     C                   ENDSR                                                              BUG13798
      /EJECT                                                                                BUG13798
      *================================================================                       CSW207
      ** SRVREC4 - Validate details screen4 fields                                            CSW207
      *================================================================                       CSW207
     C     SRVREC4       BEGSR                                                                CSW207
                                                                                              CSW207
     C                   MOVEA     '00000'       *IN(55)                                      CSW207
     C                   EVAL      PM50F1 = SO50F1                                            CSW207
     C                   EVAL      PM50F2 = SO50F2                                            CSW207
     C                   EVAL      PM50F3 = SO50F3                                            CSW207
     C                   EVAL      PM50F4 = SO50F4                                            CSW207
     C                   EVAL      PM50F5 = SO50F5                                            CSW207
                                                                                              CSW207
      * Tag blank fields for deletion                                                         CSW207
     C                   IF        SOM50FS <> *Blanks                                         CSW207
     C                             AND SO50F = *Blanks                                        CSW207
     C                   LEAVESR                                                              CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                     BUG21063
     C                   IF        PM50F1 <> *Blanks                                        BUG21063
     C                             Or (PM50F2 <> *Blanks)                                   BUG21063
     C                             Or (PM50F3 <> *Blanks                                    BUG21063
     C                             And PM50F4 = *Blanks)                                    BUG21063
     C                             Or (PM50F4 <> *Blanks                                    BUG21063
     C                             And PM50F5 = *Blanks)                                    BUG21063
                                                                                              CSW207
      *                                                                                       256637
     C                   IF        PM50F1 <> *Blanks                                          256637
     C                             Or (PM50F2 <> *Blanks)                                     256637
     C                             Or (PM50F3 <> *Blanks                                      256637
     C                             And PM50F4 = *Blanks)                                      256637
     C                             Or (PM50F4 <> *Blanks                                      256637
     C                             And PM50F5 = *Blanks)                                      256637
     C                   IF        SOMMTAG = ':59F:'                                          CSW215
     C                   EXSR      SRCallVBen                                                 CSW215
     C                   ELSE                                                                 CSW215
     C                   EXSR      SRCallVPgm                                                 CSW207
     C                   ENDIF                                                                CSW215
      *                                                                                     BUG21063
     C                   ELSE                                                               BUG21063
     C                   MOVE      *BLANKS       PrtCde                                     BUG21063
     C                   ENDIF                                                              BUG21063
                                                                                              CSW207
      *                                                                                       256637
     C                   ELSE                                                                 256637
     C                   MOVE      *BLANKS       PrtCde                                       256637
     C                   ENDIF                                                                256637
      *                                                                                       256637
     C                   IF        PrtCde ='*ERROR'                                           CSW207
     C                   EXSR      SRErrMsg                                                   CSW207
     C                   MOVEA     Arr5          *IN(55)                                      CSW207
     C                   EVAL      *IN85 = *ON                                                CSW207
     C                   EVAL      WTERR  = 'Y'                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   ENDSR                                                                CSW207
      /EJECT                                                                                  CSW207
      *================================================================                       CSW207
      ** SRErrMsg - Validate details screen4 fields                                           CSW207
      *================================================================                       CSW207
     C     SRErrMsg      BEGSR                                                                CSW207
                                                                                              CSW207
     C                   EVAL      ZAMSID = PMsgeID                                           CSW207
     C                   EVAL      ZAMSGF = 'MEMSG'                                           CSW207
     C                   EXSR      ZASNMS                                                     CSW207
     C                   EVAL      WERROR = 'Y'                                               CSW207
                                                                                              CSW207
     C                   MOVEA     '11111'       Arr5                                         CSW207
                                                                                              CSW207
     C                   ENDSR                                                                CSW207
      /EJECT                                                                                  CSW207
      *================================================================                       CSW207
      ** SRCallVPgm - Call Validation Program for 50F Tags                                    CSW207
      *================================================================                       CSW207
     C     SRCallVPgm    BEGSR                                                                CSW207
                                                                                              CSW207
     C                   CALL      'FT001000'                                                 CSW207
     C                   PARM      *BLANKS       PrtCde                                       CSW207
     C                   PARM      *BLANKS       PMsgeID                                      CSW207
     C                   PARM      *BLANK        PErrTyp                                      CSW207
     C                   PARM      'OMFM'        PVType                                       CSW207
     C                   PARM                    PM50F1           35                          CSW207
     C                   PARM                    PM50F2           35                          CSW207
     C                   PARM                    PM50F3           35                          CSW207
     C                   PARM                    PM50F4           35                          CSW207
     C                   PARM                    PM50F5           35                          CSW207
     C                   PARM                    PInpTyp                                      CSW207
     C                   PARM                    PAccount                                     CSW207
     C                   PARM                    PCust                                        CSW207
     C                   PARM                    PNonActH                                     CSW207
     C                   PARM                    SOMNWRK                                      CSW207
     C                   PARM                    SOMMTPY                                      CSW207
     C                   PARM                    SOMMTAG                                      CSW207
     C                   PARM                    SOMCTRY                                      CSW207
     C                   PARM                    SOMSBRC                                      CSW207
     C                   PARM                    SOMCURR                                      CSW207
     C                   PARM                    SOMNOST                                      CSW207
     C                   PARM                    PModInd                                      CSW207
     C                   PARM                    POut1                                        CSW207
     C                   PARM                    POut2                                        CSW207
     C                   PARM                    POut3                                        CSW207
     C                   PARM                    POut4                                        CSW207
     C                   PARM                    POut5                                        CSW207
                                                                                              CSW207
     C                   ENDSR                                                                CSW207
      /EJECT                                                                                  CSW207
      *================================================================                       CSW215
      *  SRCallVBen - Call Validation Program for 59F Tags                                    CSW215
      *================================================================                       CSW215
     C     SRCallVBen    BEGSR                                                                CSW215
                                                                                              CSW215
     C                   CALL      'MG001001'                                                 CSW215
     C                   PARM      *BLANKS       PrtCde                                       CSW215
     C                   PARM      'OMFM'        CallFrom                                     CSW215
     C                   PARM                    PM50F1                                       CSW215
     C                   PARM                    PM50F2                                       CSW215
     C                   PARM                    PM50F3                                       CSW215
     C                   PARM                    PM50F4                                       CSW215
     C                   PARM                    PM50F5                                       CSW215
     C                   PARM                    SOMNWRK                                      CSW215
     C                   PARM                    SOMMTPY                                      CSW215
     C                   PARM                    SOMMTAG                                      CSW215
     C                   PARM                    SOMCTRY                                      CSW215
     C                   PARM                    SOMSBRC                                      CSW215
     C                   PARM                    SOMCURR                                      CSW215
     C                   PARM                    SOMNOST                                      CSW215
     C                   PARM      *BLANK        POut1                                        CSW215
     C                   PARM      *BLANK        POut2                                        CSW215
     C                   PARM      *BLANK        POut3                                        CSW215
     C                   PARM      *BLANK        POut4                                        CSW215
     C                   PARM      *BLANK        POut5                                        CSW215
     C                   PARM      *BLANK        PMsgeID                                      CSW215
     C                   PARM      *BLANK        PErrTyp                                      CSW215
                                                                                              CSW215
     C                   ENDSR                                                                CSW215
      *================================================================                       CSW215
      /EJECT                                                                                  CSW215
      *================================================================
      ** SRADD - Add record
      *================================================================
     C     SRADD         BEGSR

     C*****KMEOU         CHAIN     MEOUFML0                                                   CSW207
     C**********         IF        %FOUND(MEOUFML0)                                           CSW207
     C**********         EVAL      ZAMSID = 'ME00007'                                         CSW207
     C**********         EVAL      ZAMSGF = 'MEMSG'                                           CSW207
     C**********         EXSR      ZASNMS                                                     CSW207
     C**********         EVAL      WERROR = 'Y'                                               CSW207
      **********                                                                              CSW207
     C**********         ELSE                                                                 CSW207

     C                   EVAL      OMNWRK = SOMNWRK
     C                   EVAL      OMMTPY = SOMMTPY
     C                   EVAL      OMMTAG = SOMMTAG
     C                   EVAL      OMSBRC = SOMSBRC
     C                   EVAL      OMCTRY = SOMCTRY
     C                   EVAL      OMCURR = SOMCURR
     C                   EVAL      OMNOST = SOMNOST
     C                   EVAL      OMACTI = SOMACTI
     C                   EVAL      OMFLAG = SOMFLAG
     C                   EVAL      OMDESC = SOMDESC
     C                   EVAL      OMAJOB = ##JOB
     C                   EVAL      OMAUSR = ##USR
     C                   EVAL      OMATIM = STIME
     C                   EVAL      OMARDT = BJMRDT
     C                   EVAL      OMAACT = 'I'
     C                   EVAL      OMRDNB = BJRDNB

     C                   IF        SOMACTI = '*FORMAT'                                        CSW207
     C                   EVAL      W50FS  = W50FS + 1                                         CSW207
     C                   EVALR     OM50FS = %CHAR(W50FS)                                      CSW207
     C                   EVAL      OM50F1 = SO50F1                                            CSW207
     C                   EVAL      OM50F2 = SO50F2                                            CSW207
     C                   EVAL      OM50F3 = SO50F3                                            CSW207
     C                   EVAL      OM50F4 = SO50F4                                            CSW207
     C                   EVAL      OM50F5 = SO50F5                                            CSW207
     C                   EXSR      SRCLR                                                      CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   WRITE     @OUFMPDX0                            91

      ** Display error msg if file update not successful

     C                   IF        *IN91 = '1'
     C                   EVAL      ZAMSID = 'ME00011'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   ELSE
     C                   EVAL      ZAMSID = 'ME00026'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C**********         ENDIF                                                                CSW207

     C                   ENDSR
      /EJECT
      *================================================================
      ** SRDEL - Delete record
      *================================================================
     C     SRDEL         BEGSR

     C     KMEOU         CHAIN     MEOUFML0                           60
     C                   IF        *IN60 = *ON
     C                   EVAL      ZAMSID = 'ME00008'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C                   IF        WDBRC <> SDBRC
     C                   EVAL      ZAMSID = 'ME00009'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EXSR      SRLSFF
     C                   EVAL      SDBRC = WDBRC
     C                   LEAVESR
     C                   ENDIF

     C                   DOW       NOT %EOF(MEOUFML0)                                         CSW207
     C                   DELETE    @OUFMPDX0                            91

      ** Display error msg if file update not successful

     C     *IN91         IFEQ      '1'
     C                   EVAL      ZAMSID = 'ME00011'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   ELSE                                                                 CSW207
     C                   EVAL      WFDelete = 'Y'                                             CSW207
     C                   ENDIF
                                                                                              CSW207
     C     KMEOU         READE     MEOUFML0                                                   CSW207
     C                   ENDDO                                                                CSW207

     C     EXDEL         ENDSR
      /EJECT
      *================================================================
      ** SRAMD - Amend record
      *================================================================
     C     SRAMD         BEGSR

     C                   IF        WFAmend = *Blanks                                          CSW207
     C     KMEOU         CHAIN     MEOUFML0                           60
     C                   ELSE                                                                 CSW207
     C     KMEOU0        CHAIN     MEOUFML7                           60                      CSW207
      * Add new record if not existing                                                        CSW207
     C                   IF        *IN60 = *ON                                                CSW207
     C                   EXSR      SRADD                                                      CSW207
     C                   LEAVESR                                                              CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        *IN60 = '1'
     C                   EVAL      ZAMSID = 'ME00008'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   ELSE

     C                   IF        WDBRC <> SDBRC
     C                   EVAL      ZAMSID = 'ME00009'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   EXSR      SRLSFF
     C                   EVAL      SDBRC = WDBRC
     C                   ELSE

     C                   DOW       *IN60 = *OFF                                               CSW207
     C                   EVAL      OMNWRK = SOMNWRK
     C                   EVAL      OMMTPY = SOMMTPY
     C                   EVAL      OMMTAG = SOMMTAG
     C                   EVAL      OMSBRC = SOMSBRC
     C                   EVAL      OMCTRY = SOMCTRY
     C                   EVAL      OMCURR = SOMCURR
     C                   EVAL      OMNOST = SOMNOST
     C                   EVAL      OMACTI = SOMACTI
     C                   EVAL      OMFLAG = SOMFLAG
     C                   EVAL      OMDESC = SOMDESC
     C                   EVAL      OMAJOB = ##JOB
     C                   EVAL      OMAUSR = ##USR
     C                   EVAL      OMATIM = STIME
     C                   MOVE      BJMRDT        OMRDNB
     C                   EVAL      OMAACT = 'A'

     C                   IF        SOMACTI = '*FORMAT'                                        CSW207
     C                             AND WFAmend = 'Y'                                          CSW207
     C                   EVAL      OM50F1 = SO50F1                                            CSW207
     C                   EVAL      OM50F2 = SO50F2                                            CSW207
     C                   EVAL      OM50F3 = SO50F3                                            CSW207
     C                   EVAL      OM50F4 = SO50F4                                            CSW207
     C                   EVAL      OM50F5 = SO50F5                                            CSW207
     C                   EVAL      OM50FS = SOM50FS                                           CSW207
     C                   UPDATE    @OUFMPDX7                            91                    CSW207
     C                   ELSE                                                                 CSW207
     C                   UPDATE    @OUFMPDX0                            91
     C                   ENDIF                                                                CSW207

      ** Display error msg if file update not successful

     C                   IF        *IN91 = *ON
     C                   EVAL      ZAMSID = 'ME00011'
     C                   EVAL      ZAMSGF = 'MEMSG'
     C                   EXSR      ZASNMS
     C                   EVAL      WERROR = 'Y'
     C                   LEAVESR                                                              CSW207
     C                   ELSE
     C                   EVAL      SDBRC = WDBRC
     C                   ENDIF
                                                                                              CSW207
     C                   IF        WFAmend = *Blanks                                          CSW207
     C     KMEOU         READE     MEOUFML0                               60                  CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      *IN60 = *ON                                                CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDDO                                                                CSW207
                                                                                              CSW207
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *================================================================
      ** ZASNMS - Send message to program's message queue
      *================================================================
     C     ZASNMS        BEGSR

     C                   IF        ZAPGMQ = *BLANKS
     C                   EVAL      ZAPGMQ = ##PGM
     C                   ENDIF

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
     C                   ENDSR
      /EJECT
      *================================================================
      ** SRCLR - Clear messages in program queue
      *================================================================
     C     SRCLR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      /EJECT
      *================================================================
      ** SREXIT - Exit program processing
      *================================================================
     C     SREXIT        BEGSR
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      /EJECT
      *================================================================
      ** SRRQRL - Request subfile reload
      *================================================================
     C     SRRQRL        BEGSR
     C                   EVAL      W0RSF = 'Y'
     C                   ENDSR
      /EJECT
      *================================================================                     BUG14042
      ** SRREFR - Refresh fields and reload subfile                                         BUG14042
      *================================================================                     BUG14042
     C     SRREFR        BEGSR                                                              BUG14042
     C                   EVAL      SEOMNWRK = *BLANKS                                       BUG14042
     C                   EVAL      SEOMMTPY = *BLANKS                                       BUG14042
     C                   EVAL      SEOMMTAG = *BLANKS                                       BUG14042
     C                   EVAL      SEOMSBRC = *BLANKS                                       BUG14042
     C                   EVAL      SEOMCTRY = *BLANKS                                       BUG14042
     C                   EVAL      SEOMCURR = *BLANKS                                       BUG14042
     C                   EVAL      SEOMNOST = *BLANKS                                       BUG14042
     C                   EVAL      SEOMACTI = *BLANKS                                       BUG14042
     C                   EVAL      SEOMFLAG = *BLANKS                                       BUG14042
     C                   EVAL      WERROR   = 'N'                                           BUG14042
     C                   EVAL      WF12     = 'N'                                           BUG14042
     C                   EXSR      SRCLR                                                    BUG14042
     C                   WRITE     RMSGCTL                                                  BUG14042
     C                   EXSR      SRRQRL                                                   BUG14042
     C                   ENDSR                                                              BUG14042
      /EJECT                                                                                BUG14042
      *================================================================
      ** SRLSFF - Move MEOUFML1 fields to subfile
      *================================================================
     C     SRLSFF        BEGSR

     C                   EVAL      SOMNWRK = OMNWRK
     C                   EVAL      SOMMTPY = OMMTPY
     C                   EVAL      SOMMTAG = OMMTAG
     C                   EVAL      SOMSBRC = OMSBRC
     C                   EVAL      SOMCTRY = OMCTRY
     C                   EVAL      SOMCURR = OMCURR
     C                   EVAL      SOMNOST = OMNOST
     C                   EVAL      SOMACTI = OMACTI
     C                   EVAL      SOMFLAG = OMFLAG

     C                   ENDSR
      /EJECT
      *================================================================
      ** SRISFF - Initialise subfile fields
      *================================================================
     C     SRISFF        BEGSR

     C                   EVAL      SDBRC = *BLANKS
     C                   EVAL      SCSEL = *BLANKS
     C                   EVAL      SACJN = *BLANKS
     C                   EVAL      SACUN = *BLANKS
     C                   EVAL      SACTM = *ZERO
     C                   EVAL      SACDA = *BLANKS
     C                   EVAL      SACTY = *BLANKS
     C                   EVAL      SOMNWRK = *BLANKS
     C                   EVAL      SOMMTPY = *BLANKS
     C                   EVAL      SOMMTAG = *BLANKS
     C                   EVAL      SOMSBRC = *BLANKS
     C                   EVAL      SOMCTRY = *BLANKS
     C                   EVAL      SOMCURR = *BLANKS
     C                   EVAL      SOMNOST = *BLANKS
     C                   EVAL      SOMACTI = *BLANKS
     C                   EVAL      SOMFLAG = *BLANKS

     C                   ENDSR
      /EJECT
      *================================================================
      ** SRINIT - Initialisation
      *================================================================
     C     SRINIT        BEGSR

     C                   MOVEA     CPY@          CPY2@            80

      ** Entry parameters

     C     *ENTRY        PLIST
     C                   PARM                    P0RTN
     C                   PARM                    PMMODE

      ** Update LDA with initial values for DB error fields

     C     *DTAARA       DEFINE    LDA           WLDA
     C     *LOCK         IN        WLDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'ME001750'
     C                   OUT       WLDA

      ** Update Screen Time

     C                   TIME                    STIME             6 0

      ** Get Bank's Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      *  If return with an error (LR seton in called program) then
      *  process for database error.

     C                   IF        PRTCD <> *BLANK
     C     *LOCK         IN        WLDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       WLDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get Midas Rundate

     C                   MOVE      BJMRDT        SMRDT

     C                   Z-ADD     12            WSFPG
     C                   Z-ADD     1             SSFRC

      ** Maximum record number

     C                   Z-ADD     *ZERO         WRRN

      ** Scan limit

     C                   Z-ADD     500           W0SLM

      ** Subfile pages

     C                   Z-ADD     1             W0SPG
     C                   Z-ADD     0             W0RR0
     C                   EXSR      SRCLR
     C                   Z-ADD     12            WSFLN

      ** Setup Command line

     C                   EVAL      WTXTC1 = *BLANKS
     C                   EVAL      WTXTC2 = *BLANKS
     C                   IF        PMMODE = 'M'
     C                   EVAL      WTXTC1 = FKEY1
     C                   EVAL      WTXTC2 = FKEY2
     C                   ELSE
     C                   EVAL      WTXTC2 = FKEY3
     C                   ENDIF

     C     PMMODE        IFEQ      'E'

      ** Setup title

     C                   EVAL      PMSGID = 'USR5202'
     C                   EVAL      PMSGF = 'SDUSRMSG'
     C                   EVAL      PMSGT = *BLANKS
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        WQ0286
     C     PMSGF         PARM      PMSGF         WQ0287
     C     PMSGT         PARM      PMSGT         WQ0288
     C                   EVAL      SURPT = PMSGT

     C                   ELSE

     C                   EVAL      PMSGF = 'SDUSRMSG'
     C                   EVAL      PMSGT = *BLANKS

     C                   EVAL      PMSGID = 'USR5201'
     C                   CALL      'SDRTVTXT'                           90
     C     PMSGID        PARM      PMSGID        WQ0286
     C     PMSGF         PARM      PMSGF         WQ0287
     C     PMSGT         PARM      PMSGT         WQ0288
     C                   EVAL      SURPT = PMSGT

     C                   ENDIF

     C                   EVAL      W0SLM = 99999
     C                   EVAL      WMODE = *BLANKS
     C                   EVAL      WMODE = 'CHG'

     C     KMEOU         KLIST
     C                   KFLD                    SOMNWRK
     C                   KFLD                    SOMMTPY
     C                   KFLD                    SOMMTAG
     C                   KFLD                    SOMSBRC
     C                   KFLD                    SOMCTRY
     C                   KFLD                    SOMCURR
     C                   KFLD                    SOMNOST
     C                   KFLD                    SOMACTI
                                                                                              CSW207
     C     KMEOU0        KLIST                                                                CSW207
     C                   KFLD                    SOMNWRK                                      CSW207
     C                   KFLD                    SOMMTPY                                      CSW207
     C                   KFLD                    SOMMTAG                                      CSW207
     C                   KFLD                    SOMSBRC                                      CSW207
     C                   KFLD                    SOMCTRY                                      CSW207
     C                   KFLD                    SOMCURR                                      CSW207
     C                   KFLD                    SOMNOST                                      CSW207
     C                   KFLD                    SOMACTI                                      CSW207
     C                   KFLD                    SOM50FS                                      CSW207
      *                                                                                       CSW207
      *** Check if SWIFT 2007 is installed                                                    CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM      *BLANKS       PRtCde                                       CSW207
      *                                                                                       CSW207
     C                   IF        PRtCde = *BLANKS                                           CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ENDif                                                                CSW207
      *                                                                                       CSW207
      ** Check if SWIFT 2008 is installed                                                     CSW208
      *                                                                                       CSW208
     C                   EVAL      CSW208 = 'N'                                               CSW208
     C                   CALL      'SWIF2008'                                                 CSW208
     C                   PARM      *BLANKS       PRtCde                                       CSW208
      *                                                                                       CSW208
     C                   IF        PRtCde = 'CSW2008'                                         CSW208
     C                   EVAL      CSW208 = 'Y'                                               CSW208
     C                   ENDIF                                                                CSW208
      *                                                                                       CSW208
      ** Check if SWIFT 2015 is installed                                                     CSW215
      *                                                                                       CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM      *BLANKS       PRtCde                                       CSW215
      *                                                                                       CSW215
     C                   IF        PRtCde = 'CSW2015'                                         CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ENDIF                                                                CSW215

     C                   ENDSR
      /EJECT
      *================================================================
      ** SRREPT - Call FC0040X RCF Submit - Standard functions  *
      *================================================================
     C     SRREPT        BEGSR

     C                   CALL      'FC0040X'
     C                   PARM      *BLANKS       WRTNCD                         Return code
     C**********         PARM      'ME001752'    WREPNM                         Report name BUG14042
     C                   PARM      'ME1752'      WREPNM                         Report name BUG14042
     C**********         PARM      'MEC001752'   WCOMNM                         Component NaBUG14042
     C                   PARM      'MEC1752'     WCOMNM                         Component NaBUG14042
     C                   PARM      '10001'       WCOMSQ                         Component Seque
     C                   PARM      *BLANKS       WCALLP                         Calling Paramet
     C                   PARM      'Y'           WMULTB                         Multi-branching
     C                   PARM      'S'           WLEVEL                         Level
     C                   PARM      *BLANKS       WENTITY                        Entity

     C                   ENDSR
      /EJECT
      *================================================================
      ** PSSR - Standard db error processing
      *================================================================
     C     *PSSR         BEGSR

     C/COPY SDCPYSRC,SDPSSRINTI

      *================================================================
     C                   ENDSR
      /EJECT                                                                                  CSW207
      *================================================================                       CSW207
      ** INZSF4  - Subfile 4 record initialise                                                CSW207
      *================================================================                       CSW207
     C     INZSF4        BEGSR                                                                CSW207
     C                   EVAL      SRRN  = 0                                                  CSW207
     C                   EVAL      SSRNB = 1                                                  CSW207
     C                   WRITE     RMSGCTL                                                    CSW207
                                                                                              CSW207
     C                   EVAL      *IN97 = *ON                                                CSW207
     C                   WRITE     RSFLCT4                                                    CSW207
     C                   EVAL      *IN97 = *OFF                                               CSW207
                                                                                              CSW207
      *================================================================                       CSW207
     C                   ENDSR                                                                CSW207
      /EJECT                                                                                  CSW207
      *================================================================                       CSW207
      ** PROCSF4 - Subfile 4 record process                                                   CSW207
      *================================================================                       CSW207
     C     PROCSF4       BEGSR                                                                CSW207
                                                                                              CSW207
     C                   DOW       *IN03 = *OFF AND                                           CSW207
     C                             *IN12 = *OFF                                               CSW207
     C                   IF        UPDATEC = 'N'                                              CSW207
     C                   IF        *IN27 = *OFF                                               CSW207
     C                   EXSR      INZSF4                                                     CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      RECCTR = 0                                                 CSW207
     C                   ENDIF                                                                CSW207
     C                   EXSR      LOADSF4                                                    CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        *IN27 = *ON                                                CSW207
     C                   EVAL      SSRNB = SRRN                                               CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   IF        SCSEL = 'D'                                                CSW207
     C                   EVAL      SCTX2 = FKEY4B                                             CSW207
     C                   EVAL      *IN95 = *ON                                                CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      SCTX2 = FKEY4A                                             CSW207
     C                   EVAL      *IN95 = *OFF                                               CSW207
     C                   ENDIF                                                                CSW207
     C                   WRITE     RCMDTXT2                                                   CSW207
                                                                                              CSW207
     C                   EXFMT     RSFLCT4                                                    CSW207
                                                                                              CSW207
     C                   IF        *IN29 = *OFF OR                                            CSW207
     C                             *IN10 = *ON                                                CSW207
     C                   LEAVESR                                                              CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDDO                                                                CSW207
                                                                                              CSW207
      *================================================================                       CSW207
     C                   ENDSR                                                                CSW207
      /EJECT                                                                                  CSW207
      *================================================================                       CSW207
      ** LOADSF4 - Subfile 4 record load subfile                                              CSW207
      *================================================================                       CSW207
     C     LOADSF4       BEGSR                                                                CSW207
                                                                                              CSW207
     C     KMEOU         CHAIN     MEOUFML1                                                   CSW207
     C                   IF        %FOUND(MEOUFML1)                                           CSW207
     C                   DOW       NOT %EOF(MEOUFML1) AND                                     CSW207
     C                             *IN27 = *OFF                                               CSW207
     C                   EVALR     SOM50FS = OM50FS                                           CSW207
     C                   EVAL      SO50F1  = %TRIM(OM50F1)                                    CSW207
     C                   EVAL      SO50F2  = %TRIM(OM50F2)                                    CSW207
     C                   EVAL      SO50F3  = %TRIM(OM50F3)                                    CSW207
     C                   EVAL      SO50F4  = %TRIM(OM50F4)                                    CSW207
     C                   EVAL      SO50F5  = %TRIM(OM50F5)                                    CSW207
     C                   EVAL      SRRN    = SRRN  + 1                                        CSW207
     C                   EVAL      RECCTR  = RECCTR + 1                                       CSW207
     C                   MOVE      OM50FS        W50FS                                        CSW207
     C                   WRITE     RSFLRC4                                                    CSW207
     C     KMEOU         READE     MEOUFML1                                                   CSW207
     C                   ENDDO                                                                CSW207
                                                                                              CSW207
     C                   ELSE                                                                 CSW207
                                                                                              CSW207
     C                   EVAL      W50FS   = 0                                                CSW207
     C                   DOW       (SRRN  < W0SLM AND                                         CSW207
     C                             RECCTR < MAXREC)                                           CSW207
     C                   EVALR     SOM50FS = *BLANKS                                          CSW207
     C                   EVAL      SO50F1  = *BLANKS                                          CSW207
     C                   EVAL      SO50F2  = *BLANKS                                          CSW207
     C                   EVAL      SO50F3  = *BLANKS                                          CSW207
     C                   EVAL      SO50F4  = *BLANKS                                          CSW207
     C                   EVAL      SO50F5  = *BLANKS                                          CSW207
     C                   EVAL      SRRN    = SRRN  + 1                                        CSW207
     C                   EVAL      RECCTR  = RECCTR + 1                                       CSW207
     C                   WRITE     RSFLRC4                                                    CSW207
     C                   ENDDO                                                                CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EVAL      REM = %REM(RECCTR:MAXREC)                                  CSW207
     C                   DOW       (SRRN  < W0SLM AND                                         CSW207
     C                             REM <> 0) OR                                               CSW207
     C                             (*IN27 = *ON AND                                           CSW207
     C                             RECCTR < MAXREC)                                           CSW207
     C                   EVALR     SOM50FS = *BLANKS                                          CSW207
     C                   EVAL      SO50F1  = *BLANKS                                          CSW207
     C                   EVAL      SO50F2  = *BLANKS                                          CSW207
     C                   EVAL      SO50F3  = *BLANKS                                          CSW207
     C                   EVAL      SO50F4  = *BLANKS                                          CSW207
     C                   EVAL      SO50F5  = *BLANKS                                          CSW207
     C                   EVAL      SRRN    = SRRN  + 1                                        CSW207
     C                   EVAL      RECCTR  = RECCTR + 1                                       CSW207
     C                   WRITE     RSFLRC4                                                    CSW207
     C                   EVAL      REM = %REM(RECCTR:MAXREC)                                  CSW207
     C                   ENDDO                                                                CSW207
                                                                                              CSW207
      *================================================================                       CSW207
     C                   ENDSR                                                                CSW207
                                                                                              CSW207
**CTDATA CPY@
(c) Finastra International Limited 2006
