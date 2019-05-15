     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Accounting Rules Monitor Delete process')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL000600*-*Midas*OF*Accounting*Rules*Monitor******************                     MD029739
      *  DI000600 - Midas OF Accounting Rules Monitor                 *                     MD029739
      *             Delete process                                    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD029739 *RENAMED* Date 15Aug14               *
      *                 MD024772           Date 03Feb14               *
      *                 MD023269 *CREATE   Date 22Nov13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD029739 - File renaming for integration layer.              *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries. (Recompile)                            *
      *  MD023629 - Accounting Rules Process                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     ** File DS
     **   Midas GL Accounting Rules Interface File
     D DSACIFTD      E DS                  EXTNAME(DIACIFTD)

      **   Midas OF Meridian Intellimatch RAW data
     D*DSACMETD*     E DS                  EXTNAME(IGACMETD)                                MD029739
     D DSACMETD      E DS                  EXTNAME(DIACMETD)                                MD029739

      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+

      ** Parameters for access object programs
     D @RTCD           S              7
     D @OPTN           S              7
     D @SARD           S              6

     D WRun            S              1

      ** Parameter list fields
     D PBTID           S             60                                         Batch Id
     D PTMST           S             26                                         AR Status


      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      * Init Processing
     C                   EXSR      INIT

      * End Processing
     C                   EXSR      END

     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Initiation Subroutine to check if Batch ID already  *
      *           processed                                           *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      *
      ***Delete*records*in*IGACMETD*and*DIACIFTD***********************                     MD029739
      ** Delete records in DIACMETD and DIACIFTD                                            MD029739
      *
      ***Then*Delete*record*in*IGACMETD********************************                     MD029739
      ** Then Delete record in DIACMETD                                                     MD029739
     C/Exec SQL
     C*+*********        Delete from IGACMETD                                               MD029739
     C+                  Delete from DIACMETD                                               MD029739
     C+                          where XFTMSP = :PTMST
     C/End-Exec
      ** then Access DIACIFTD and delete all records
     C/Exec SQL
     C+                  Delete from DIACIFTD
     C+                          where IFBTID = :PBTID
     C/End-Exec
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PBTID
     C                   PARM                    PTMST

      ** Set off program indicators
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF

     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

      ** Access Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @OPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END    - End program                                         *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     END           BEGSR

     C                   EVAL      *INLR = *On

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On

     C                   RETURN

     C                   ENDSR
      *****************************************************************
