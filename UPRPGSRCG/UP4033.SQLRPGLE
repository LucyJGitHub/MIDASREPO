     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP CFTA summary report')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP4033 - CFTA summary report                                 *
      *                                                               *
      *  (c) Finastra International 2022                              *
      *                                                               *
      *  Last Amend No. MD059732 *CREATE   Date 18Aug22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059732 - DDS improvements, report conflict only            *
      *           - Applied for MD-60291.                             *      
      *                                                               *
      *****************************************************************
     FUP4033P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D Recursive       S              1
      *
     D                 DS
      *
      /SPACE 3
      *
      *
      ** Program Status Data Structure
      *

     D UPCFTN        E DS                  EXTNAME(UPCFTNTD)

     **************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    LAYER             7
      *

     C                   eval      R_LAYR = LAYER

      * Write main page header.
     C                   WRITE     HEADH

      * Read log file and process for each entry
     C/exec SQL
     C+ declare CursorRdG cursor for
     C+ select *
     C+ from UPCFTNTD
     C+ order by X_FILE
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :UPCFTN
     C/end-exec

     C                   If        SQLCODE = 100
     C                   WRITE     NORECS
     C                   else

     C                   WRITE     HEADER
     C                   DOW       SQLCODE = 0

      * If records are found print details
     C                   EXSR      Details

      * Read next record.
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :UPCFTN
     C/end-exec

     C                   ENDDO
     C                   Endif

      * Write trailer and end program.
     C                   WRITE     TRAILP

     C/exec SQL
     C+ close CursorRdG
     C/end-exec

     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * Details -                                                     *
      *                                                               *
      *****************************************************************
     C     Details       BEGSR

     C                   clear                   DETAIL


      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     HEADER
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF

     C                   eval      R_FILE =  X_FILE
     C                   eval      R_NOCFT = %char(%dec(X_CFTN/2:5:0))

     C                   WRITE     DETAIL

     C     DetailsE      ENDSR


      /EJECT

      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
