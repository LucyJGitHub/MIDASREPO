/*STD *  CM                                                          */
/*EXI *  SYSIFCOPT(*IFSIO)                                           */
/*EXI *  TEXT('Midas @24 KWG response file copy')
     /****************************************************************/
     /*                                                              */
     /*  Midas - European Reporting Module                           */
     /*                                                              */
     /*  ER000113 - Copy response file                               */
     /*                                                              */
     /*  Function  : Copy response file to database file.            */
     /*                                                              */
     /*  (c) Finastra International Limited 2008                     */
     /*                                                              */
     /*  Last Amend No. MD046248              Date 27Oct17           */
     /*  Prev Amend No. CER059                Date 19Jul10           */
     /*                 CER047  *CREATE       Date 19May08           */
     /*                                                              */
     /****************************************************************/
     /*                                                              */
     /*  MD046248 - Finastra Rebranding                              */
     /*  CER059 - German Feature Upgrade to Delhi                    */
     /*  CER047 - German Features LF037-00 Reporting @24c KWG        */
     /*                                                              */
     /****************************************************************/
     /*                                                              */
     /*P Purpose                                                     */
     /*P ~~~~~~~                                                     */
     /*P This program copies the response file of a §24 KWG          */
     /*P transmission to the database workfile GWV11P.               */
     /****************************************************************/
     /*    Compilation Options for command CRTBNDC                   */
     /*    Keywords              Keyword choices                     */
     /*C   OUTPUT(*PRINT)      - {*PRINT or *NONE}                   */
     /*C   OPTION(*SHOWUSR)    - {*NONE or <compiler option>}        */
     /*C   DBGVIEW(*LIST)      - {*NONE,*ALL,*STMT,*SOURCE or *LIST} */
     /*C   SYSIFCOPT(*IFSIO)   - {*NOIFSIO or *IFSIO}                */
     /****************************************************************/

#include <stdio.h>
#include <recio.h>
#include <stdlib.h>
#include <string.h>
#include <decimal.h>
#include <fcntl.h>
#include <unistd.h>

/* Include the external definition of the database file GWV11P.      */
/* The #pragma statement creates a typedef struct that holds the     */
/* structure of the database file. This structure is then imported   */
/* by the #include statement.                                        */


#ifdef __cplusplus
#include <bcd.h>
#else
#include <decimal.h>
#endif

typedef _Packed struct {

#ifndef __cplusplus
   decimal( 4, 0) F1WLEN;
#else
   _DecimalT< 4, 0> F1WLEN;              /* Length of data */
                                         /* BCD class SPECIFIED IN DDS */
#endif
   char F1WDTA[32760];                   /* Data */
} ERTRCVPD_ERTRCVD0_i_t;


/* Define work values.                                               */

typedef int BOOLEAN ;
#define FALSE             0
#define TRUE              1

#define OK                0
#define OPENSTMFFAILED    1
#define OPENDBAFFAILED    2
#define WRITEDBAFFAILED   3

/* Main procedure.                                                   */
/* One parameter is passed from the calling program, consist of      */
/* full path of the file to copy from. This parameter must be        */
/* passed as NULL terminated string.                                 */

int ER000113(const char *stmfile, char bkn)
{

/* Declare rcd, dta of data structure type                           */
/* ERTRCVPD_ERTRCVD0_i_t.                                            */
/* The data structure type was defined from the DDS specified (see   */
/* #pragma statement above).                                         */

  ERTRCVPD_ERTRCVD0_i_t rcd, *dta = &rcd;
  _RFILE       *out;
  _RIOFB_T     *fb;
  FILE         *fildes;
  char         *dbfile   = "ERTRCVPD";
  int          c, i;
  int          length    = 0;
  int          offset    = 0;
  BOOLEAN      mode      = FALSE;

/* Init F1WDTA.                                                      */

  for (i = 0; i < sizeof( rcd.F1WDTA ); i++)
    rcd.F1WDTA[i] = '\0';

/* Open the stream file for read using the fopen().                  */

  if (( fildes = fopen( stmfile, "rb" )) == NULL )
  {
    return OPENSTMFFAILED;
  }
  else
  {

/* Open the database file.                                           */

    if (( out = _Ropen( dbfile, "wr" )) == NULL )
    {
      return OPENDBAFFAILED;
    }
    else
    {

/* Read character by character from stream file until EOF and place  */
/* it into GWDTA at position offset.                                 */

      while ((c = fgetc (fildes)) != EOF )
      {
        rcd.F1WDTA[offset] = (char) c;

/* Switch record processing according to 'Betreiberkennung'          */

        switch( bkn )
        {

/* Record processing for BANK-VERLAG.                                */

        case 'B':

/* Depending on current mode the chracters from the file are         */
/* treatened as 4 byte integer value or pure data.                   */
/* It is assumed that the first 4 characters of each record are a    */
/* 4 byte integer value that consist of the total size of a record.  */

          switch( mode )
          {

/* Read 4 byte integer.                                              */

          case FALSE:
            switch ( offset )
            {
            case 0:
              c *= 256;
            case 1:
              c *= 256;
            case 2:
              c *= 256;
            };
            length += c;
            if (++offset >= 4)    /* 4 bytes read. Integer complete. */
            {
              mode = TRUE;
            };
            break;

/* Read pure data.                                                   */

          case TRUE:
            if (++offset >= length) /* All bytes read. Record complete.*/
            {

/* Set fields of database file.                                      */

              rcd.F1WLEN = (decimal (4, 0)) length;

/* Write record to the database file.                                */

              fb = _Rwrite( out, dta, sizeof(rcd) );
              if ( fb->num_bytes != sizeof(rcd) )
              {
                return WRITEDBAFFAILED;
              };

/* Clear F1WDTA.                                                     */

              for (i = 0; i < length; i++)
                rcd.F1WDTA[i] = '\0';

/* Reset length and offset. Set mode to read 4 byte integer.         */

              length = 0;
              offset = 0;
              mode = FALSE;
            };
            break;

          };            /* End switch(mode) */
          break;

/* Record processing for T-SYSTEMS.                                  */

        case 'T':

/* Read characters until a CRLF (X'0D0A') is found. This indicates   */
/* the end of a record.                                              */

          offset++;
          if ( c == 13 )                   /* Hex 0D detected        */
          {
            c = fgetc (fildes);            /* Read Hex 0A            */

/* Set fields of database file.                                      */

            rcd.F1WLEN = (decimal (4, 0)) offset;

/* Write record to the database file.                                */

            fb = _Rwrite( out, dta, sizeof(rcd) );
            if ( fb->num_bytes != sizeof(rcd) )
            {
              return WRITEDBAFFAILED;
            };

/* Clear F1WDTA.                                                      */

            for (i = 0; i < offset; i++)
              rcd.F1WDTA[i] = '\0';

/* Reset offset.                                                     */

            offset = 0;
          };
          break;

        };              /* End switch(bkn)  */

      };                /* End while(...)   */

/* Close database file.                                              */

      _Rclose( out );
    };

/* Close stream file.                                                */

    fclose ( fildes );
  };
  return OK;
}
