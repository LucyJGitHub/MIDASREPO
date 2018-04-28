     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MG FRA/IRS Deletion/Cancellation Control')       *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  MG922000 - Midas MG FRA/IRS Deletion/Cancellation Control    *
      *                                                               *
      *  Function:  This program will handle the deletion/cancellation*
      *             of MT340, MT360, MT361 and MT341                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029017           Date 25Nov14               *
      *  Prev Amend No. MD028226           Date 07Jul14               *
      *                 MD022052           Date 09Sep13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD029017 - Tag 22A value is AMND instead of NEWT             *
      *  MD028226 - Deletion of FRA transaction did not create a      *
      *             cancellation entry on MGF340TR archive file when  *
      *             MGST of message in MGOREFPD is 'RSND'             *
      *  MD022052 - Action amend_Amend maturity date where trade repo *
      *             has SWIFT Id_MT360 for trade repo is not generated*
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
     FMGOREFL0  IF   E           K DISK
 
      ** Local data area for database error details
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Data structure to redefine TRNO as 6 long numeric field
 
     D                 DS
     D  K#TRNO                 1     16
     D  K#MODI                 1      2
     D  K#MTRN                 3      8
     D  K#TRID                 9     14
     D  K#SEQN                15     16  0
 
     D                 DS
     D  TRNO                   1     16
     D  TRNO#N                 3      8  0
 
      ** Data Structure for Module details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      **  Data structure for Switchable Features file
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Data Structure for access programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Work Variables                                                                     MD022052
     D PModi           S              2                                                     MD022052
     D PTran           S             15A                                                    MD022052
     D PProg           S              2A                                                    MD022052
     D PMode           S              1A                                                    MD022052
     D PLSWC           S              3  0                                                  MD022052
     D PLSWS           S              3  0                                                  MD022052
     D PERCD           S              1A                                                    MD022052
     D CSW213          S              1A                                                    MD022052
     D PRTCD           S              7A                                                    MD022052
                                                                                            MD022052
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Main Process                                                 *
      *****************************************************************
 
      ** Accept values from calling program(s)
 
     C     *ENTRY        PLIST
     C                   PARM                    P#TRNO            6 0
     C                   PARM                    P#TRID            6
     C                   PARM                    P#MODI            2
     C                   PARM                    P#MTYP            3
     C                   PARM                    P#TREF           16
     C                   PARM                    P#RTCD            1
 
      ** Perform Initial Process
 
     C                   EXSR      SRINIT
 
      ** Access last generated message for transaction number
 
     C     K#TRNO        SETGT     MGOREFD0                             75
     C                   READP     MGOREFD0                               75
 
      ** Do while not beginning of file and transaction number of
      ** LF/MGOREFL0 = Transaction Number of calling program and
      ** message found indicator is off
 
     C                   DOW       *IN75 = '0'
     C                             AND *IN76 = '0'
     C                             AND P#TRNO = TRNO#N
 
     C                   IF        MTPY = P#MTYP
 
     C                   EXSR      SRCALL
 
     C                   IF        P#RTCD = 'C'
     C                   EVALR     P#TREF = TRNO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READP     MGOREFD0                               75
 
     C                   ENDDO
 
      ** End Program
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCALL - Call Deletion or Cancellation program               *
      *****************************************************************
     C     SRCALL        BEGSR
 
     C                   IF        MGST = 'CRTD'
     C                             OR MGST = 'AMND'
     C**********                   OR MGST = 'RSND'                                         MD028226
 
     C                   CALL      'MG920500'                           77
     C                   PARM                    TRNO
     C                   PARM                    MODI
     C                   PARM      *BLANKS       P#RTCD
 
      ** If MG9205 not found , set up LDA and return to calling program
 
     C                   IF        *IN77 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   EVALR     DBKEY = 'MG920500 NOT FOUND'
     C                   EVAL      DBFILE = *BLANKS
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If database error in MG920500 return control to calling
      ** program
 
     C                   IF        P#RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   END
 
     C                   IF        BGCFMT = 'Y'
     C                             AND MTPY = '340'
     C                             OR BGCFMT = 'Y'
     C                             AND MTPY = '341'
 
      ** Also, generate cancellation message for message types
      ** '360' and '361 if CCF003 switchable feature is on
 
     C                             OR CCF003 = 'Y'
     C                             AND MTPY = '360'
     C                             OR CCF003 = 'Y'
     C                             AND MTPY = '361'
 
     C                   CALL      'MG921000'                           78
     C                   PARM                    TRNO
     C                   PARM                    MODI
     C                   PARM      *BLANKS       P#RTCD
 
      ** If MG921000 not found, set up LDA and return to calling
      ** program
 
     C                   IF        *IN78 = '1'
     C     *LOCK         IN        LDA
 
     C                   Z-ADD     3             DBASE
     C                   EVALR     DBKEY = 'MG921000 NOT FOUND'
     C                   EVAL      DBFILE = *BLANKS
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   END
 
      ** If database error in MG921000 return control to calling
      ** program
 
     C**********         IF        P#RTCD = *BLANKS                                         MD029017
     C                   IF        P#RTCD <> *BLANKS                                        MD029017
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        MGSG = '2'
     C                             OR MGSG = '3'
 
     C                   EVALR     P#RTCD = 'C'
     C                   EVALR     *IN76 = '1'
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *   SRINIT - Initial Process                                    *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Set up Local Data Area (LDA)
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVALR     DBFILE = *BLANKS
     C                   EVALR     DBKEY = *BLANKS
     C                   MOVEL(P)  'MG922000'    DBPGM
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
 
      **  Set up key field for access of MGOREFL0 with values from
      **  calling program.
 
     C                   EVALR     K#MODI = P#MODI
     C                   EVALR     K#TRID = P#TRID
     C                   EVAL      K#SEQN = *HIVAL
 
     C                   MOVE      P#TRNO        K#MTRN
 
     C                   EVAL      *IN76 = '0'
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       RTCDA
     C                   PARM      '*FIRST '     OPTION            7
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** If a DB error , set up LDA and return to calling program
 
     C                   IF        RTCDA <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     OPTION        DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      ** Access Switchable features file to see if CCF003 is switched
      ** ON.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       RTCDA             7
     C                   PARM      '*VERIFY'     RTCDB             7
     C                   PARM      'CCF003'      RTCDC             6
 
     C                   IF        RTCDA = *BLANKS
     C                   MOVE      'Y'           CCF003            1
     C                   ELSE
     C                   EVALR     CCF003 = 'N'
     C                   ENDIF
 
      *                                                                                     MD022052
      ** Check if SWIFT 2013 changes is installed                                           MD022052
      *                                                                                     MD022052
     C                   CALL      'SWIF2013'                                               MD022052
     C                   PARM      *BLANKS       PRTCD                                      MD022052
                                                                                            MD022052
     C                   IF        PRTCD = 'CSW2013'                                        MD022052
     C                   EVAL      CSW213 = 'Y'                                             MD022052
     C                   ENDIF                                                              MD022052
                                                                                            MD022052
     C                   IF        CSW213 = 'Y'                                             MD022052
     C                   EVAL      PTRAN = K#MTRN                                           MD022052
     C                                                                                      MD022052
                                                                                            MD022052
     C                   CALL      'MG5000'                                                 MD022052
     C                   PARM      P#MODI        PMODI                                      MD022052
     C                   PARM                    PTRAN                                      MD022052
     C                   PARM      'CE'          PPROG                                      MD022052
     C                   PARM      *BLANKS       PMODE                                      MD022052
     C                   PARM      *ZEROS        PLSWC                                      MD022052
     C                   PARM      *ZEROS        PLSWS                                      MD022052
     C                   PARM      *BLANKS       PERCD                                      MD022052
                                                                                            MD022052
     C                   IF        PERCD = 'Y'                                              MD022052
     C     *LOCK         IN        LDA                                                      MD022052
     C                   Z-ADD     4             DBASE                                      MD022052
     C                   EVAL      DBKEY = PTRAN                                            MD022052
     C                   EVAL      DBFILE = 'MG5000'                                        MD022052
     C                   OUT       LDA                                                      MD022052
     C                   EXSR      *PSSR                                                    MD022052
     C                   ENDIF                                                              MD022052
                                                                                            MD022052
     C                   EVAL      K#SEQN = PLSWS                                           MD022052
     C                   ENDIF                                                              MD022052
                                                                                            MD022052
     C                   ENDSR
      *****************************************************************
      *   *PSSR - Error Handling                                      *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      P#RTCD = 'E'
     C                   SETON                                            LR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
