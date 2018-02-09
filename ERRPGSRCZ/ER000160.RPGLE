     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Bundesbank Decision Table Selection')         *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000160 - Midas ER Bundesbank Decision Table Selection      *
      *                                                               *
      *  Function:  This program is used to navigate either to the    *
      *             account code or transaction type decision table.  *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG25881           Date 03Sep09               *
      *                 BUG25878           Date 03Sep09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25881 - Transaction Type Table calls the wrong I/C and    *
      *             COB report request prompt.                        *
      *  BUG25878 - German Features Link Testing fix                  *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  ZASNMS    - Send Message to Program Message Queue            *
      *  *INZSR    - Initialise                                       *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** Midas ER Bundesbank Decision Table Selection Display file
 
     FER000160DFCF   E             WORKSTN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
     D PAction         S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PMsgf           S             10A   INZ('STUSRMSG')
     D PPgm            S             10A
     D PPgrl           S              5A
     D PMsgID          S              7A
     D PMsgDta         S            132A
     D PMsgTp          S              7A
 
     D I#COTT          S             10A
     D I#CSEQ          S              5A
     D I#REPT          S             10A
     D I#BRCH          S              1A
     D I#SEQ           S              5A
     D I#ACT           S              1A
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************
 
      ** Do while F3 is not pressed
 
     C                   DOW       *INKC = '0'
 
     C                   WRITE     ER000160C0
     C                   EXFMT     ER000160F1
 
     C                   CALL      'Y2CLMSC'
     C                   PARM                    PPgm
     C                   PARM      '*SAME'       PPgrl
 
     C                   MOVEA     '00'          *IN(20)                                    BUG25878
     C                   IF        *IN45 = '0'
 
     C                   IF        DHACOD <> *BLANKS AND
     C                             DHTRNT <> *BLANKS
     C                   EVAL      *IN21 = '1'                                              BUG25878
     C                   EVAL      *IN20 = '1'
     C                   EVAL      PMsgID = 'ER20001'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   IF        DHACOD <> 'X'                                            BUG25878
     C                             AND DHTRNT <> 'X'                                        BUG25878
     C                   IF        DHACOD <> ' '                                            BUG25878
     C                   EVAL      *IN20 = '1'                                              BUG25878
     C                   EVAL      PMsgID = 'ERC0001'                                       BUG25878
     C                   EXSR      ZASNMS                                                   BUG25878
     C                   ENDIF                                                              BUG25878
     C                   IF        DHTRNT <> ' '                                            BUG25878
     C                   EVAL      *IN21 = '1'                                              BUG25878
     C                   EVAL      PMsgID = 'ERC0001'                                       BUG25878
     C                   EXSR      ZASNMS                                                   BUG25878
     C                   ENDIF                                                              BUG25878
     C                   ELSE                                                               BUG25878
 
     C                   EVAL      *IN20 = '0'
     C                   SELECT
     C                   WHEN      PAction = 'I'
      *                                                                                     BUG25881
     C                   IF        DHACOD = 'X'                                             BUG25881
     C                   MOVEL     'ERC000175'   I#COTT                                     BUG25881
     C                   MOVEL     'ER000175'    I#REPT                                     BUG25881
     C                   ELSEIF    DHTRNT = 'X'                                             BUG25881
     C                   MOVEL     'ERC000185'   I#COTT                                     BUG25881
     C                   MOVEL     'ER000185'    I#REPT                                     BUG25881
     C                   ENDIF                                                              BUG25881
      *                                                                                     BUG25881
     C                   CALL      'FCC0202'
     C**********         PARM      'ERC000175'   I#COTT                                     BUG25881
     C                   PARM                    I#COTT                                     BUG25881
     C                   PARM      '10001'       I#CSEQ
     C**********         PARM      'ER000175'    I#REPT                                     BUG25881
     C                   PARM                    I#REPT                                     BUG25881
     C                   PARM      ' '           I#BRCH
     C                   WHEN      PAction = 'C'
      *                                                                                     BUG25881
     C                   IF        DHACOD = 'X'                                             BUG25881
     C                   MOVEL     'ERC000175'   I#COTT                                     BUG25881
     C                   MOVEL     'ER000175'    I#REPT                                     BUG25881
     C                   ELSEIF    DHTRNT = 'X'                                             BUG25881
     C                   MOVEL     'ERC000185'   I#COTT                                     BUG25881
     C                   MOVEL     'ER000185'    I#REPT                                     BUG25881
     C                   ENDIF                                                              BUG25881
      *                                                                                     BUG25881
     C                   CALL      'FCC0204'
     C**********         PARM      'ERC000175'   I#COTT                                     BUG25881
     C                   PARM                    I#COTT                                     BUG25881
     C                   PARM      '10001'       I#CSEQ
     C**********         PARM      'ER000175'    I#REPT                                     BUG25881
     C                   PARM                    I#REPT                                     BUG25881
     C                   PARM      '     '       I#SEQ
     C                   PARM      ' '           I#BRCH
     C                   PARM      'I'           I#ACT
     C                   OTHER
 
     C                   IF        DHACOD = 'X'
     C                   CALL      'ER000170'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PAction
     C                   IF        PRtcd  = '*EXIT'
     C                   EVAL      *INKC  = *ON
     C                   ENDIF
     C                   EVAL      DHACOD = *BLANKS
 
     C                   ELSEIF    DHTRNT = 'X'
     C                   CALL      'ER000180'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PAction
     C                   IF        PRtcd  = '*EXIT'
     C                   EVAL      *INKC  = *ON
     C                   ENDIF
     C                   EVAL      DHTRNT = *BLANKS
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF                                                              BUG25878
     C                   ENDIF
     C                   ELSE                                                               BUG25878
     C                   EVAL      DHACOD = *BLANKS                                         BUG25878
     C                   EVAL      DHTRNT = *BLANKS                                         BUG25878
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send Message to Program Message Queue               *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     ZASNMS        BEGSR
     C                   CALL      'Y2SNMGC'
     C                   PARM                    PPgm
     C                   PARM                    PPgrl
     C                   PARM                    PMsgID
     C                   PARM                    PMsgf
     C                   PARM                    PMsgDta
     C                   PARM                    PMsgTp
     C                   ENDSR
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PAction
 
      ** Initialise LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'ER000160'
     C                   OUT       LDA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 001
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PPgm    = DBPGM
     C                   EVAL      PPgrl   = *BLANKS
     C                   EVAL      PMsgDta = *BLANKS
     C                   EVAL      PMsgTp  = *BLANKS
     C                   EVAL      PMsgID  = *BLANKS
 
     C                   EVAL      DDPGMQ  = '*'
 
     C                   SELECT
     C                   WHEN      PAction = 'I'
     C                   EVAL      MODE    = 'List (I/C)'
     C                   WHEN      PAction = 'C'
     C                   EVAL      MODE    = 'List (COB)'
     C                   WHEN      PAction = 'A'
     C                   EVAL      MODE    = 'Maintenance'
     C                   OTHER
     C                   EVAL      MODE    = 'Enquiry'
     C                   ENDSL
     C                   EVAL      *IN30   = *ON                                            BUG25878
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
